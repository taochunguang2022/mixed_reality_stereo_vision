% This script calculates the betweenness centrality for each node in two datasets (ds_A and ds_B).   
% Betweenness centrality measures the frequency with which a node appears as an intermediate point on the shortest paths between all pairs of nodes in a network.
% The script first initializes predecessor matrices to track the shortest paths.
% It then uses the Floyd-Warshall algorithm to compute these paths, updating the predecessor matrices accordingly.
% For each node pair, the script increments the betweenness centrality of any node that appears on their shortest path. 
% Finally, it normalizes the betweenness centrality scores (betweenness_centrality_ratio_A and betweenness_centrality_ratio_B) to allow comparison across different-sized networks.
pred_A = cell(channel_number);

total_shortest_paths = channel_number * (channel_number - 1) / 2;

for i = 1:channel_number
    for j = 1:channel_number
        if adjacency_matrix_A(i, j) < inf && i ~= j
            pred_A{i, j} = i;
        else
            pred_A{i, j} = [];
        end
    end
end


for k = 1:channel_number
    for i = 1:channel_number
        for j = 1:channel_number
            if A_D(i, k) + A_D(k, j) < A_D(i, j)
                A_D(i, j) = A_D(i, k) + A_D(k, j);
                
              
                first_part_A = pred_A{i, k};
                if ~isempty(first_part_A) && first_part_A(end) == k
                    first_part_A = first_part_A(1:end-1);
                end
                
                second_part_A = pred_A{k, j};
                if ~isempty(second_part_A) && second_part_A(1) == k
                    second_part_A = second_part_A(2:end);
                end
                
                pred_A{i, j} = [first_part_A, k, second_part_A];
            end
        end
    end
end

betweenness_centrality_A = zeros(channel_number, 1);

for i = 1:channel_number
    for j = 1:channel_number 
        if ~isempty(pred_A{i, j})
            path_A = [i, pred_A{i, j}, j];
            for p = 3:length(path_A)-1 
                betweenness_centrality_A(path_A(p)) = betweenness_centrality_A(path_A(p)) + 1;
            end
        end
    end
end

betweenness_centrality_ratio_A = betweenness_centrality_A / total_shortest_paths;
d1 = mean(betweenness_centrality_ratio_A);
d3 = sum(betweenness_centrality_ratio_A);

pred_B = cell(channel_number);

for i = 1:channel_number
    for j = 1:channel_number
        if adjacency_matrix_B(i, j) < inf && i ~= j
            pred_B{i, j} = i;
        else
            pred_B{i, j} = [];
        end
    end
end


for k = 1:channel_number
    for i = 1:channel_number
        for j = 1:channel_number
            if B_D(i, k) + B_D(k, j) < B_D(i, j)
                B_D(i, j) = B_D(i, k) + B_D(k, j);
                
                
                first_part_B = pred_B{i, k};
                if ~isempty(first_part_B) && first_part_B(end) == k
                    first_part_B = first_part_B(1:end-1);
                end
                
                second_part_B = pred_B{k, j};
                if ~isempty(second_part_B) && second_part_B(1) == k
                    second_part_B = second_part_B(2:end);
                end
                
                pred_B{i, j} = [first_part_B, k, second_part_B];
            end
        end
    end
end


betweenness_centrality_B = zeros(channel_number, 1);


for i = 1:channel_number
    for j = 1:channel_number 
        if ~isempty(pred_B{i, j})
            path_B = [i, pred_B{i, j}, j]; 
            for p = 3:length(path_B)-1 
                betweenness_centrality_B(path_B(p)) = betweenness_centrality_B(path_B(p)) + 1;
            end
        end
    end
end


betweenness_centrality_ratio_B = betweenness_centrality_B / total_shortest_paths;
d2 = mean(betweenness_centrality_ratio_B);
d4 = sum(betweenness_centrality_ratio_B);
