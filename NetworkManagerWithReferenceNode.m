classdef NetworkManagerWithReferenceNode < NetworkMangerBase
    properties (SetAccess = protected)
        num_nodes
        node_positions
        adjacent_matrix
        stochastic_adjacency_matrix
        connection_rate
    end

    methods (Access = public)
        function obj = NetworkManagerWithReferenceNode(obj,args)
            obj@NetworkManagerBase(args);
            obj.num_nodes = args.num_nodes_nonref+1;
            obj.node_positions = vertcat(args.node_positions_nonref, args.node_position_ref);
            obj.adjacent_matrix = zeros(args.num_nodes, args.num_nodes);
            obj.stochastic_adjacency_matrix = zeros((size(obj.adjacent_matrix)));
            obj.connection_rate = zeros(1, args.num_nodes);
        end
    end
end