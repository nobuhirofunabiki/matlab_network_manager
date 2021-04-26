classdef NetworkManagerNormal < NetworkManagerBase
    properties (SetAccess = protected)
        num_nodes
        node_positions
        adjacent_matrix
        stochastic_adjacency_matrix
        connection_rate
        reachable_nodes
    end

    methods (Access = public)
        function obj = NetworkManagerNormal(args)
            obj@NetworkManagerBase(args);
            obj.num_nodes = args.num_nodes;
            obj.node_positions = args.node_positions;
            obj.adjacent_matrix = zeros(args.num_nodes, args.num_nodes);
            obj.stochastic_adjacency_matrix = zeros((size(obj.adjacent_matrix)));
            obj.connection_rate = zeros(obj.num_nodes, args.num_steps);
        end
    end

    methods (Access = protected)
        function calculateReachableNodes(this, iSteps);
            % temporary comment
        end
    end
end