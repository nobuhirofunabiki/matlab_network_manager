classdef NetworkGraphExpression < handle
    properties (SetAccess = private)
        num_nodes
        node_positions
        adjacent_matrix
        range_threshold
        connection_rate
    end
    methods
        function obj = NetworkGraphExpression(args)
            obj.num_nodes = args.num_nodes;
            obj.node_positions = args.node_positions;
            obj.adjacent_matrix = zeros(args.num_nodes, args.num_nodes);
            obj.range_threshold = args.range_threshold;
            obj.connection_rate = zeros(1, args.num_nodes);
        end

        function updateAdjacentMatrixByRange(this)
            NUM_NODES = this.num_nodes;
            for iNode = 1:NUM_NODES-1
                for jNode = iNode+1:NUM_NODES
                    distance_ij = this.getDistanceBetween2Nodes(iNode, jNode);
                    if (distance_ij <= this.range_threshold)
                        this.adjacent_matrix(iNode, jNode) = 1;
                        this.adjacent_matrix(jNode, iNode) = 1;
                    else
                        this.adjacent_matrix(iNode, jNode) = 0;
                        this.adjacent_matrix(jNode, iNode) = 0;
                    end
                end
            end
            this.updateConnectionRate();
        end

        function updateConnectionRate(this)
            NUM_NODES = this.num_nodes;
            for iNode = 1:NUM_NODES
                sum_adjacent = sum(this.adjacent_matrix(iNode,:));
                this.connection_rate(1, iNode) = sum_adjacent/(NUM_NODES-1);
            end
        end

        % Set functions
        function setNodePositions(this, args_positions)
            this.node_positions = args_positions;
        end
        function setRangeThreshold(this, arg_range)
            this.range_threshold = arg_range;
        end

        % Get functions
        function output = getConnectionRate(this)
            output = this.connection_rate;
        end
        function output = getAdjacentMatrix(this)
            output = this.adjacent_matrix;
        end
        function output = getDistanceBetween2Nodes(this, node1, node2)
            pos_node1 = this.node_positions(:,node1);
            pos_node2 = this.node_positions(:,node2);
            output = norm(pos_node1 - pos_node2);
        end

        % Visualization
        function visualizeConnectionRate(this)
            connection_rate_percent = 100.0*this.connection_rate;
            b = bar(connection_rate_percent);
            b.FaceColor = 'flat';
            for iNode = 1:this.num_nodes
                conection_rate_iNode = connection_rate_percent(1,iNode);
                if (conection_rate_iNode >= 75)
                    b.CData(iNode,:) = [0 0 1];
                elseif (conection_rate_iNode >= 50 && conection_rate_iNode < 75)
                    b.CData(iNode,:) = [0 1 0];
                elseif (conection_rate_iNode >= 25 && conection_rate_iNode < 50)
                    b.CData(iNode,:) = [1 1 0];
                else
                    b.CData(iNode,:) = [1 0 0];
                end
            end
            ylim([0,100]);
            ylabel('Connection Rate [%]');
            hold on
        end
        function visualizeNodePositions2D(this)
            for iNode = 1:this.num_nodes
                x = this.node_positions(1,iNode);
                y = this.node_positions(2,iNode);
                scatter(x, y, 'k');
                hold on
            end
        end
        function visualizeConnectedNetwork2D(this)
            NUM_NODES = this.num_nodes;
            for iNode = 1:NUM_NODES-1
                for jNode = iNode+1:NUM_NODES
                    if (this.adjacent_matrix(iNode, jNode) == 1)
                        pos = this.node_positions;
                        x_vector = [pos(1,iNode), pos(1,jNode)];
                        y_vector = [pos(2,iNode), pos(2,jNode)];
                        plot(x_vector, y_vector, 'k');
                        hold on
                    end
                end
            end
        end
        function visualizeConnectedNetwork3D(this)
            NUM_NODES = this.num_nodes;
            for iNode = 1:NUM_NODES-1
                for jNode = iNode+1:NUM_NODES
                    if (this.adjacent_matrix(iNode, jNode) == 1)
                        pos = this.node_positions;
                        x_vector = [pos(1,iNode), pos(1,jNode)];
                        y_vector = [pos(2,iNode), pos(2,jNode)];
                        z_vector = [pos(3,iNode), pos(3,jNode)];
                        plot3(x_vector, y_vector, z_vector, 'k');
                        hold on
                    end
                end
            end
        end
    end
end