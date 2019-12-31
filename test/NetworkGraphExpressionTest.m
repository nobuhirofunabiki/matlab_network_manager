classdef NetworkGraphExpressionTest < matlab.unittest.TestCase
    properties
        nge_
    end

    methods(TestMethodSetup)
        function createNetworkGraphExpression(testCase)
            NUM_NODES = 4;
            NUM_DIM = 2;
            args.num_nodes = NUM_NODES;
            node_positions = zeros(NUM_DIM, NUM_NODES);
            node_positions(:,1) = [0; 0];
            node_positions(:,2) = [0; 1];
            node_positions(:,3) = [1; 0];
            node_positions(:,4) = [2; 1];
            args.node_positions = node_positions;
            args.range_threshold = 1.0;
            testCase.nge_ = NetworkGraphExpression(args);
        end
    end

    methods(Test)
        function testUpdateAdjacentMatrixByRange(testCase)
            nge_ = testCase.nge_;
            % Case1:
            nge_.updateAdjacentMatrixByRange();
            adjacent_matrix = [0 1 1 0; 1 0 0 0; 1 0 0 0; 0 0 0 0];
            testCase.verifyEqual(nge_.getAdjacentMatrix(), adjacent_matrix);
            % Case2:
            nge_.setRangeThreshold(1.5);
            nge_.updateAdjacentMatrixByRange();
            adjacent_matrix = [0 1 1 0; 1 0 1 0; 1 1 0 1; 0 0 1 0];
            testCase.verifyEqual(nge_.getAdjacentMatrix(), adjacent_matrix);
            % Case3:
            nge_.setRangeThreshold(2.0);
            nge_.updateAdjacentMatrixByRange();
            adjacent_matrix = [0 1 1 0; 1 0 1 1; 1 1 0 1; 0 1 1 0];
            testCase.verifyEqual(nge_.getAdjacentMatrix(), adjacent_matrix);
        end
        function testUpdateStochasticAdjacencyMatrix(testCase)
            nge_ = testCase.nge_;
            nge_.setRangeThreshold(1.5);
            nge_.updateAdjacentMatrixByRange();
            nge_.updateStochasticAdjacencyMatrix();
            matrix_actual = nge_.getStochasticAdjacencyMatrix();
            matrix_expected = [1/6 1/2 1/3 0; 1/2 1/6 1/3 0; 1/3 1/3 0 1/3; 0 0 1/3 2/3];
            testCase.verifyEqual(matrix_actual, matrix_expected,'AbsTol', 10^(-10));
        end
        function testUpdateConnectionRate(testCase)
            nge_ = testCase.nge_;
            nge_.setRangeThreshold(2.0);
            nge_.updateAdjacentMatrixByRange();
            nge_.updateConnectionRate();
            connection_rate = [2/3 1 1 2/3];
            testCase.verifyEqual(nge_.getConnectionRate(), connection_rate);
        end
        function testGetDistanceBetween2Nodes(testCase)
            nge_ = testCase.nge_;
            d12 = nge_.getDistanceBetween2Nodes(1, 2);
            d13 = nge_.getDistanceBetween2Nodes(1, 3);
            d14 = nge_.getDistanceBetween2Nodes(1, 4);
            d23 = nge_.getDistanceBetween2Nodes(2, 3);
            d24 = nge_.getDistanceBetween2Nodes(2, 4);
            d34 = nge_.getDistanceBetween2Nodes(3, 4);
            testCase.verifyEqual(1.0, d12);
            testCase.verifyEqual(1.0, d13);
            testCase.verifyEqual(sqrt(5.0), d14);
            testCase.verifyEqual(sqrt(2.0), d23);
            testCase.verifyEqual(2.0, d24);
            testCase.verifyEqual(sqrt(2.0), d34);
        end
        function testVisualizeNetwork2D(testCase)
            nge_ = testCase.nge_;
            nge_.setRangeThreshold(2.0);
            nge_.updateAdjacentMatrixByRange();
            figure
            nge_.visualizeNodePositions2D();
            nge_.visualizeConnectedNetwork2D();
        end
        function testVisualizeConnectionRate(testCase)
            nge_ = testCase.nge_;
            nge_.setRangeThreshold(2.0);
            nge_.updateAdjacentMatrixByRange();
            nge_.updateConnectionRate();
            figure
            nge_.visualizeConnectionRate();
        end
    end
end