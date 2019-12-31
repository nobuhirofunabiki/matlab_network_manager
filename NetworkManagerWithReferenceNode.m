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
            obj.stochastic_adjacency_matrix = zeros((size(obj.adjacent_matrix)));
            obj.connection_rate = zeros(1, obj.num_nodes);
        end

        function setNodePositions(this, positions_nonref, position_ref)
            this.node_positions = horzcat(positions_nonref, position_ref);
        end

    end
end