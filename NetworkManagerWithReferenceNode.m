classdef NetworkManagerWithReferenceNode < NetworkManagerBase
    properties (SetAccess = protected)
        num_nodes
        node_positions
        adjacent_matrix
        stochastic_adjacency_matrix
        connection_rate
    end

    methods (Access = public)
        function obj = NetworkManagerWithReferenceNode(args)
            obj@NetworkManagerBase(args);
            obj.num_nodes = args.num_nodes_nonref+1;
            obj.node_positions = horzcat(args.node_positions_nonref, args.node_position_ref);
            obj.adjacent_matrix = zeros(obj.num_nodes, obj.num_nodes);
            % obj.stochastic_adjacency_matrix = zeros((size(obj.adjacent_matrix)));
            obj.stochastic_adjacency_matrix = zeros(args.num_nodes_nonref, args.num_nodes_nonref);
            obj.connection_rate = zeros(1, obj.num_nodes);
        end

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

        function output = getDigreeAtNode(this, iAgents)
            adjacent_matrix = this.adjacent_matrix;
            adjacent_matrix(this.num_nodes, :) = [];
            adjacent_matrix(:, this.num_nodes) = [];
            output = sum(adjacent_matrix(iAgents,:));
        end

        function setNodePositions(this, positions_nonref, position_ref)
            this.node_positions = horzcat(positions_nonref, position_ref);
        end

    end
end