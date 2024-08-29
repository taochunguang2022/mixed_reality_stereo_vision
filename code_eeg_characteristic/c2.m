% This script calculates the local and global clustering coefficients for two datasets, ds_A and ds_B. For each node, it determines its neighbors and counts the number of connections (edges) between these neighbors to compute the local clustering coefficient, which measures how closely the node's neighbors are connected to each other. 
% The global clustering coefficient for each dataset (global_clustering_coefficient_A and global_clustering_coefficient_B) is then calculated as the average of all local clustering coefficients, providing insight into the overall tendency of nodes to form tightly knit groups within the network. 
local_clustering_A = zeros(channel_number, 1);
for i = 1:channel_number
    k = degrees_A(i);
    neighbors_A = zeros(k, 1); 
    count = 1; 
    
    
    for j = 1:channel_number
        if adjacency_matrix_A(i, j) ~= 0 && adjacency_matrix_A(i, j) ~= inf
            neighbors_A(count) = j;
            count = count + 1;
        end
    end
       
    if k > 1
        EI = 0; 
        for p = 1:length(neighbors_A)
            for m = p+1:length(neighbors_A)
                if adjacency_matrix_A(neighbors_A(p), neighbors_A(m)) ~= 0 && adjacency_matrix_A(neighbors_A(p), neighbors_A(m)) ~= inf
                    EI = EI + 1; 
                end
            end
        end
        local_clustering_A(i) = 2 * EI / (k * (k - 1)); 
    else
        local_clustering_A(i) = 0;
    end
end
global_clustering_coefficient_A = mean(local_clustering_A);


local_clustering_B = zeros(channel_number, 1);
for i = 1:channel_number
    k = degrees_B(i);
    neighbors_B = zeros(k, 1); 
    count = 1; 
    
   
    for j = 1:channel_number
        if adjacency_matrix_B(i, j) ~= 0 && adjacency_matrix_B(i, j) ~= inf
            neighbors_B(count) = j;
            count = count + 1;
        end
    end
       
    if k > 1
        EI = 0; 
        for p = 1:length(neighbors_B)
            for m = p+1:length(neighbors_B)
                if adjacency_matrix_B(neighbors_B(p), neighbors_B(m)) ~= 0 && adjacency_matrix_B(neighbors_B(p), neighbors_B(m)) ~= inf
                    EI = EI + 1;
                end
            end
        end
        local_clustering_B(i) = 2 * EI / (k * (k - 1)); 
    else
        local_clustering_B(i) = 0;
    end
end
global_clustering_coefficient_B = mean(local_clustering_B); 

