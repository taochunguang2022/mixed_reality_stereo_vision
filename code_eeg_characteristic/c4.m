% This script calculates the average path length between all pairs of nodes for two datasets (ds_A and ds_B). 
% It first initializes matrices (FA and FB) to store the lengths of the shortest paths between each node pair. 
% If no path exists between two nodes, it assigns an infinite length. 
% It then extracts the upper triangular portions of these matrices (upper_triangle_FA and upper_triangle_FB), setting infinite values to zero to ignore unreachable node pairs. 
% The script computes the sum of the valid path lengths and calculates the average path length (average_path_length_FA and average_path_length_FB) for each dataset, providing a measure of the overall connectivity within each network.
FA = zeros(channel_number, channel_number); 
 
for i = 1:channel_number
    for j = 1:channel_number
        if isempty(pred_A{i, j})
            FA(i, j) = Inf;  
        else
            
            FA(i, j) = length(pred_A{i, j});
        end
    end
end


upper_triangle_FA = triu(FA, 1);


upper_triangle_FA(upper_triangle_FA == Inf) = 0;


sum_of_paths_FA = sum(upper_triangle_FA(:));


average_path_length_FA = sum_of_paths_FA / (n*(n-1));

FB = zeros(channel_number, channel_number); 

for i = 1:channel_number
    for j = 1:channel_number
        if isempty(pred_B{i, j})
            FB(i, j) = Inf;  
        else
            
            FB(i, j) = length(pred_B{i, j});
        end
    end
end

upper_triangle_FB = triu(FB, 1);

upper_triangle_FB(upper_triangle_FB == Inf) = 0;

sum_of_paths_FB = sum(upper_triangle_FB(:));

average_path_length_FB = sum_of_paths_FB / (n*(n-1));