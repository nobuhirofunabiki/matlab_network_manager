classdef NetworkManagerWithReferenceNode < NetworkManagerBase
    properties (SetAccess = protected)
        num_nodes
        node_positions
        adjacent_matrix
        stochastic_adjacency_matrix
        connection_rate
        reachable_nodes
    end

    methods (Access = public)
        function obj = NetworkManagerWithReferenceNode(args)
            obj@NetworkManagerBase(args);
            obj.num_nodes = args.num_nodes_nonref+1;
            obj.node_positions = horzcat(args.node_positions_nonref, args.node_position_ref);
            obj.adjacent_matrix = zeros(obj.num_nodes, obj.num_nodes);
            obj.stochastic_adjacency_matrix = zeros(args.num_nodes_nonref, args.num_nodes_nonref);
            obj.connection_rate = zeros(obj.num_nodes, args.num_steps);
            obj.reachable_nodes = zeros(obj.num_nodes-1, args.num_steps);
        end
    end

    methods (Access = protected)
        function updateStochasticAdjacencyMatrix(this)
            this.stochastic_adjacency_matrix = ...
                zeros(size(this.stochastic_adjacency_matrix));
            NUM_NODES = this.num_nodes - 1;
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
            NUM_NODES = this.num_nodes-1;
            adjacent_matrix = this.adjacent_matrix(1:NUM_NODES, 1:NUM_NODES);
            for iNode = 1:NUM_NODES
                sum_adjacent = sum(adjacent_matrix(iNode,:));
                this.connection_rate(iNode, iSteps) = sum_adjacent/(NUM_NODES-1);
            end
        end

        function calculateReachableNodes(this, iSteps)
            NUM_NODES = this.num_nodes-1;
            adjacent_matrix = this.adjacent_matrix(1:NUM_NODES, 1:NUM_NODES);
            G = graph(adjacent_matrix);
            d = distances(G,'Method','unweighted');
            for iNodes = 1:NUM_NODES
                count = 0;
                for jNodes = 1:NUM_NODES
                    if d(iNodes, jNodes) ~= Inf
                        count = count + 1; 
                    end
                end
                this.reachable_nodes(iNodes,iSteps) = count;
            end
        end
    end

    methods (Access = public)
        function output = getDigreeAtNode(this, iAgents)
            adjacent_matrix = this.adjacent_matrix;
            adjacent_matrix(this.num_nodes, :) = [];
            adjacent_matrix(:, this.num_nodes) = [];
            output = sum(adjacent_matrix(iAgents,:));
        end

        function setNodePositions(this, positions_nonref, position_ref)
            this.node_positions = horzcat(positions_nonref, position_ref);
        end

        function visualizeConnectionRate(this, line_width)
            hold on
            num_nodes = this.num_nodes - 1;
            plots = [];
            plot_names = {};
            color_list = colormap(jet(num_nodes));
            for iNodes = 1:num_nodes
                plot_iNodes = plot(this.time_list, 100.0*this.connection_rate(iNodes,:), ...
                    'Color', color_list(iNodes,:), ...
                    'LineWidth', line_width);
                plots = horzcat(plots, [plot_iNodes]);
                name = strcat('sat-', int2str(iNodes));
                plot_names = horzcat(plot_names, {name});
            end
            max_rate = 100.0*ones(1,length(this.time_list));
            plot_max = plot(this.time_list, max_rate, ...
                'Color', 'k', ...
                'LineStyle', '--', ...
                'LineWidth', line_width);
            plots = horzcat(plots, [plot_max]);
            plot_names = horzcat(plot_names, {'max rate'});
            legend(plots, plot_names, 'Location', 'eastoutside', 'FontSize', 8);
            ylim([0, 110])
        end

        function visualizeReachableNodes(this, line_width)
            hold on
            num_nodes = this.num_nodes - 1;
            plots = [];
            plot_names = {};
            color_list = colormap(jet(num_nodes));
            for iNodes = 1:num_nodes
                plot_iNodes = plot(this.time_list, this.reachable_nodes(iNodes,:), ...
                    'Color', color_list(iNodes,:), ...
                    'LineWidth', line_width);
                plots = horzcat(plots, [plot_iNodes]);
                name = strcat('sat-', int2str(iNodes));
                plot_names = horzcat(plot_names, {name});
            end
            max_reachable_nodes = num_nodes*ones(1,length(this.time_list));
            plot_max = plot(this.time_list, max_reachable_nodes, ...
                'Color', 'k', ...
                'LineStyle', '--', ...
                'LineWidth', line_width);
            plots = horzcat(plots, [plot_max]);
            plot_names = horzcat(plot_names, {'max number'});
            legend(plots, plot_names, 'Location', 'eastoutside', 'FontSize', 8);
            ylim([0, num_nodes+2])
        end
    end
end