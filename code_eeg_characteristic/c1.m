% This script analyzes the connectivity of two datasets (ds_A and ds_B) by calculating several graph-based metrics. 
% It computes the degree of each node and normalizes these degrees, constructs adjacency matrices to represent connection strengths, and determines the shortest paths between all node pairs using the Floyd-Warshall algorithm. 
% The script also calculates the average path lengths and extracts specific path lengths for connected node pairs, providing a comprehensive overview of the connectivity structure within each dataset.
degrees_A = zeros(channel_number, 1); % 初始化度数组
degrees_B = zeros(channel_number, 1); % 初始化度数组


for i = 1:size(ds_A.chanPairs, 1)
   
    electrode1_A  = ds_A.chanPairs(i, 1);
    electrode2_A  = ds_A.chanPairs(i, 2);

   
    degrees_A (electrode1_A ) = degrees_A (electrode1_A ) + 1;
    degrees_A (electrode2_A ) = degrees_A (electrode2_A ) + 1;
end


for i = 1:size(ds_B.chanPairs, 1)
    
    electrode1_B  = ds_B.chanPairs(i, 1);
    electrode2_B  = ds_B.chanPairs(i, 2);

    
    degrees_B (electrode1_B ) = degrees_B (electrode1_B ) + 1;
    degrees_B (electrode2_B ) = degrees_B (electrode2_B ) + 1;
end

max_degree = channel_number - 1;

degree_ratios_A  = zeros(channel_number, 1);
degree_ratios_B  = zeros(channel_number, 1);


for i = 1:channel_number
    degree_ratios_A (i) = degrees_A (i) / max_degree;
end

for i = 1:channel_number
    degree_ratios_B (i) = degrees_B (i) / max_degree;
end

Deg_A = mean(degree_ratios_A);
Deg_B = mean(degree_ratios_B);


adjacency_matrix_A = inf(channel_number);
diag_indices_A = sub2ind([channel_number, channel_number], 1:channel_number, 1:channel_number); 
adjacency_matrix_A(diag_indices_A) = 0; 


for i = 1:size(ds_A.chanPairs, 1)
    adjacency_matrix_A(ds_A.chanPairs(i, 1), ds_A.chanPairs(i, 2)) = ds_A.connectStrength(i);
    adjacency_matrix_A(ds_A.chanPairs(i, 2), ds_A.chanPairs(i, 1)) = ds_A.connectStrength(i); 
end


n = size(adjacency_matrix_A, 1);
D_A = adjacency_matrix_A; 
A_D = adjacency_matrix_A; 

for k = 1:n 
    for i = 1:n 
        for j = 1:n 
            D_A(i, j) = min(D_A(i, j), D_A(i, k) + D_A(k, j));
        end
    end
end

upper_triangle_A = triu(D_A, 1);


upper_triangle_A(upper_triangle_A == Inf) = 0;


sum_of_paths_A = sum(upper_triangle_A(:));


average_path_length_A = sum_of_paths_A / (n*(n-1));


path_lengths_A = arrayfun(@(x) D_A(ds_A.chanPairs(x, 1), ds_A.chanPairs(x, 2)), 1:size(ds_A.chanPairs, 1));
p1 = path_lengths_A';
p11 = sum(path_lengths_A(:)) / (n*(n-1));


adjacency_matrix_B = inf(channel_number);
diag_indices_B = sub2ind([channel_number, channel_number], 1:channel_number, 1:channel_number); 
adjacency_matrix_B(diag_indices_B) = 0; 


for i = 1:size(ds_B.chanPairs, 1)
    adjacency_matrix_B(ds_B.chanPairs(i, 1), ds_B.chanPairs(i, 2)) = ds_B.connectStrength(i);
    adjacency_matrix_B(ds_B.chanPairs(i, 2), ds_B.chanPairs(i, 1)) = ds_B.connectStrength(i); 
end


n = size(adjacency_matrix_B, 1);
D_B = adjacency_matrix_B;
B_D = adjacency_matrix_B; 

for k = 1:n 
    for i = 1:n 
        for j = 1:n 
            D_B(i, j) = min(D_B(i, j), D_B(i, k) + D_B(k, j));
        end
    end
end


upper_triangle_B = triu(D_B, 1);


upper_triangle_B(upper_triangle_B == Inf) = 0;


sum_of_paths_B = sum(upper_triangle_B(:));


average_path_length_B = sum_of_paths_B / (n*(n-1));


path_lengths_B = arrayfun(@(x) D_B(ds_B.chanPairs(x, 1), ds_B.chanPairs(x, 2)), 1:size(ds_B.chanPairs, 1));

p2 = path_lengths_B';
p21 = sum(path_lengths_B(:)) / (n*(n-1));
