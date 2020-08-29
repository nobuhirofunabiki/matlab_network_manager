clc
clear
% close all;

addpath(genpath('../../matlab_network_manager'));
addpath(genpath('../../common_utilities'));

node_positions_table = readmatrix('node_positions_30nodes.csv');
% node_positions_table = readmatrix('node_positions_simple.csv');

cg_ = ColorGenerator();

% % For node_positions_simple
% time_step = 4;
% node_positions = zeros(3,3);
% for i=1:3
%     j=(i-1)*3;
%     node_positions(1,i) = node_positions_table(time_step,j+1);
%     node_positions(2,i) = node_positions_table(time_step,j+2);
%     node_positions(3,i) = node_positions_table(time_step,j+3);
% end

% % For node_positions_simple
% args.num_steps = 1;
% args.num_nodes = 3;
% args.node_positions = node_positions;
% args.range_threshold = 1500;
% network_ = NetworkManagerNormal(args);
% network_.updateNetwork(1, 0);

% For node_positions_30nodes
time_step = 1;
num_nodes = 30
node_positions = zeros(3,num_nodes);
for iNodes=1:num_nodes
    j=(iNodes-1)*3;
    node_positions(1,iNodes) = node_positions_table(time_step,j+1);
    node_positions(2,iNodes) = node_positions_table(time_step,j+2);
    node_positions(3,iNodes) = node_positions_table(time_step,j+3);
end

% For node_positions_30nodes
args.num_steps = 1;
args.num_nodes = num_nodes;
args.node_positions = node_positions;
args.range_threshold = 1500;
network_ = NetworkManagerNormal(args);
network_.updateNetwork(1, 0);

% Visualization
figure
hold on
% network
args_v_network.line_color = 'k';
args_v_network.line_style = '-';
args_v_network.line_width = 2;
network_.visualizeConnectedNetwork3DCustomized(args_v_network);
% agent
marker_symbol = 'o';
marker_size = 60;
marker_edge_color = 'k';
marker_face_color = cg_.getNormalizedRGB('ruri');
for iAgents = 1:num_nodes
    scatter3(node_positions(1,iAgents), node_positions(2,iAgents), node_positions(3,iAgents), ...
        'Marker', marker_symbol, ...
        'SizeData', marker_size, ...
        'MarkerEdgeColor', marker_edge_color, ...
        'MarkerFaceColor', marker_face_color);
end
scatter3(0,0,0.1)
axis equal
grid on
ax = gca;
xlabel('X [m]','FontSize',12)
ylabel('Y [m]','FontSize',12)
zlabel('Z [m]','FontSize',12)
ax.FontSize = 10;

% For time_step = 3
% ax.XLim = [-200 200];
% ax.YLim = [-100 300];
% ax.ZLim = [-100 100];