classdef NetworkManagerBase < handle
    properties (SetAccess = protected)
        range_threshold
        time_list
    end

    properties (Abstract = true, SetAccess = protected)
        num_nodes
        node_positions
        adjacent_matrix
        stochastic_adjacency_matrix
        connection_rate
        reachable_nodes
    end

    methods (Access = protected)
        function obj = NetworkManagerBase(args)
            obj.range_threshold = args.range_threshold;
            obj.time_list = zeros(1, args.num_steps);
        end
    end

    methods (Access = public)
        function updateNetwork(this, iSteps, time)
            this.time_list(1, iSteps) = time;
            this.updateAdjacentMatrixByRange();
            this.updateStochasticAdjacencyMatrix();
            this.updateConnectionRate(iSteps);
            this.calculateReachableNodes(iSteps);
        end
    end

    methods(Access = protected, Abstract = true)
        calculateReachableNodes(this, iSteps);
    end
    
    methods (Access = protected)
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
            % this.updateConnectionRate();
        end

        function updateStochasticAdjacencyMatrix(this)
            this.stochastic_adjacency_matrix = ...
                zeros(size(this.stochastic_adjacency_matrix));
            NUM_NODES = this.num_nodes;
            for iNodes = 1:NUM_NODES
                for jNodes = 1:NUM_NODES
                    if (this.adjacent_matrix(iNodes, jNodes) == 1)
                        this.stochastic_adjacency_matrix(iNodes, jNodes) = ...
                            1.0/max(this.getDigreeAtNode(iNodes), this.getDigreeAtNode(jNodes));
                    end
                end
            end
            for iNodes = 1:NUM_NODES
                this.stochastic_adjacency_matrix(iNodes, iNodes) = ...
                    1.0 - sum(this.stochastic_adjacency_matrix(iNodes,:));
            end
        end

        function updateConnectionRate(this, iSteps)
            NUM_NODES = this.num_nodes;
            for iNode = 1:NUM_NODES
                sum_adjacent = sum(this.adjacent_matrix(iNode,:));
                this.connection_rate(iNode, iSteps) = sum_adjacent/(NUM_NODES-1);
            end
        end
    end
    
    methods (Access = public)

        % Set functions
        function setNodePositions(this, args_positions)
            this.node_positions = args_positions;
        end

        function setRangeThreshold(this, arg_range)
            this.range_threshold = arg_range;
        end

        function setAdjacentMatrixElement(this, iRows, iCols, b_connected)
            assert(b_connected == 0 || b_connected == 1, 'Invalid argument');
            this.adjacent_matrix(iRows, iCols) = b_connected;
        end

        % Get functions
        function output = getConnectionRate(this)
            output = this.connection_rate;
        end

        function output = getAdjacentMatrix(this)
            output = this.adjacent_matrix;
        end

        function output = getLocalAdjacentMatrix(this, iNodes)
            output = zeros(size(this.adjacent_matrix));
            output(iNodes,:) = this.adjacent_matrix(iNodes,:);
            output(:,iNodes) = this.adjacent_matrix(:,iNodes);
        end

        function output = getStochasticAdjacencyMatrix(this)
            output = this.stochastic_adjacency_matrix;
        end

        function output = getDistanceBetween2Nodes(this, node1, node2)
            pos_node1 = this.node_positions(:,node1);
            pos_node2 = this.node_positions(:,node2);
            output = norm(pos_node1 - pos_node2);
        end
        
        function output = getDigreeAtNode(this, iAgents)
            output = sum(this.adjacent_matrix(iAgents,:));
        end

        % Visualization
        function visualizeConnectionRate(this, line_width)
            hold on
            plots = [];
            plot_names = {};
            color_list = colormap(jet(this.num_nodes));
            for iNodes = 1:this.num_nodes
                plot_iNodes = plot(this.time_list, 100.0*this.connection_rate(iNodes,:), ...
                    'Color', color_list(iNodes,:), ...
                    'LineWidth', line_width);
                plots = horzcat(plots, [plot_iNodes]);
                plot_names = horzcat(plot_names, {int2str(iNodes)});
            end
            legend(plots, plot_names, 'Location', 'northwest', 'FontSize', 8);
            ylim([0, 100])
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

        function visualizeConnectedNetwork2DCustomized(this, args)
            line_color = args.line_color;
            line_style = args.line_style;
            line_width = args.line_width;
            NUM_NODES = this.num_nodes;
            for iNode = 1:NUM_NODES-1
                for jNode = iNode+1:NUM_NODES
                    if (this.adjacent_matrix(iNode, jNode) == 1)
                        pos = this.node_positions;
                        x_vector = [pos(1,iNode), pos(1,jNode)];
                        y_vector = [pos(2,iNode), pos(2,jNode)];
                        plot(x_vector, y_vector, ...
                        'Color', line_color, ...
                        'LineStyle', line_style, ...
                        'LineWidth', line_width);
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

        function visualizeConnectedNetwork3DCustomized(this, args)
            line_color = args.line_color;
            line_style = args.line_style;
            line_width = args.line_width;
            NUM_NODES = this.num_nodes;
            for iNode = 1:NUM_NODES-1
                for jNode = iNode+1:NUM_NODES
                    if (this.adjacent_matrix(iNode, jNode) == 1)
                        pos = this.node_positions;
                        x_vector = [pos(1,iNode), pos(1,jNode)];
                        y_vector = [pos(2,iNode), pos(2,jNode)];
                        z_vector = [pos(3,iNode), pos(3,jNode)];
                        plot3(x_vector, y_vector, z_vector, ...
                        'Color', line_color, ...
                        'LineStyle', line_style, ...
                        'LineWidth', line_width);
                        hold on
                    end
                end
            end
        end

    end
end