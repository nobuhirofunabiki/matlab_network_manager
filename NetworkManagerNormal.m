classdef NetworkManagerNormal < NetworkManagerBase
    properties (SetAccess = protected)
        num_nodes
        node_positions
        adjacent_matrix
        stochastic_adjacency_matrix
        connection_rate
    end

    methods (Access = public)
        function obj = NetworkManagerNormal(args)
            obj@NetworkManagerBase(args);
            obj.num_nodes = args.num_nodes;
            obj.node_positions = args.node_positions;
            obj.adjacent_matrix = zeros(args.num_nodes, args.num_nodes);
            obj.stochastic_adjacency_matrix = zeros((size(obj.adjacent_matrix)));
            obj.connection_rate = zeros(1, args.num_nodes);
        end
    end
end