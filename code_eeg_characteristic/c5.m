% This script calculates the node efficiency and average node efficiency for each node in two datasets (ds_A and ds_B). 
% Node efficiency measures how efficiently information is exchanged between a given node and all other nodes in the network. 
% For each node, the script computes the sum of the inverse shortest path lengths to all other nodes, excluding itself, to determine the node efficiency (node_efficiency_A and node_efficiency_B). 
% It then calculates the average efficiency across all nodes (avg_node_efficiency_A and avg_node_efficiency_B) for each dataset, providing insight into the overall efficiency of information transfer within the networks.

node_efficiency_A = zeros(channel_number, 1);
node_efficiency_B = zeros(channel_number, 1);
 
for j = 1:channel_number
    sum_inverse_path_lengths = 0;
    for k = 1:channel_number
        if j ~= k && FA(j, k) ~= Inf
            sum_inverse_path_lengths = sum_inverse_path_lengths + 1 / FA(j, k);
        end
    end
    node_efficiency_A(j) = sum_inverse_path_lengths / (channel_number - 1);
end
 
for j = 1:channel_number
    sum_inverse_path_lengths = 0;
    for k = 1:channel_number
        if j ~= k && FB(j, k) ~= Inf
            sum_inverse_path_lengths = sum_inverse_path_lengths + 1 / FB(j, k);
        end
    end
    node_efficiency_B(j) = sum_inverse_path_lengths / (channel_number - 1);
end
 
avg_node_efficiency_A = mean(node_efficiency_A);
avg_node_efficiency_B = mean(node_efficiency_B);
 
