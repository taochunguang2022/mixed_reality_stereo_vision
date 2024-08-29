clc;clear all;close all

%% Specify relevant information
[filename1, pathname1, filterindex] = uigetfile('*.mat', 'Pick the mat file of measures of one condition (group)'); 
[filename2, pathname2, filterindex] = uigetfile('*.mat', 'Pick the mat file of measures of the other condition (group)'); 

[filename3, pathname3, filterindex] = uigetfile('*.set', 'Pick an eeglab file used to computed the measures'); 

test_type = inputdlg('Test Type? Paired t-test = 1 Independent t-test = 0'); 
test_type = str2num(test_type{1});

name1 = inputdlg('the name of one condition (group)'); 
name1 = name1{1};

name2 = inputdlg('the name of the other condition (group)'); 
name2 = name2{1};

%% Load some eeglab-formatted EEG data to get information about that experiment's EEG data
EEG = pop_loadset('filename',filename3,'filepath',pathname3);
chanlocs = EEG.chanlocs; 
channel_number = size(EEG.data,1); 
fc_number = channel_number*(channel_number-1)/2; 

%% Determine which two electrodes correspond to each electrode pair
pairs = nchoosek(1:channel_number,2); 

%% Indicators that are included in both conditions (or groups)
A_fc  = importdata(strcat(pathname1,filename1)); % 载入第一个条件或者第一组被试的功能连接矩阵，维度是电极*电极*被试
B_fc  = importdata(strcat(pathname2,filename2)); % 载入第二个条件或者第二组被试的功能连接矩阵，维度是电极*电极*被试

%% Plot the total average connectivity of the two conditions (or groups) separately
A_fc_avg = mean(A_fc,3); 
A_fc_avg2 = zeros(fc_number,1); 
for i = 1:fc_number
    A_fc_avg2(i,1) = A_fc_avg(pairs(i,1),pairs(i,2));
end  

B_fc_avg = mean(B_fc,3);
B_fc_avg2 = zeros(fc_number,1);
for i = 1:fc_number
    B_fc_avg2(i,1) = B_fc_avg(pairs(i,1),pairs(i,2));
end        

threshold = 0.72;
% Filtering and mapping the first condition
[idx_row_A, idx_col_A] = find(triu(A_fc_avg, 1) > threshold);  
idx_pairs_A = find(ismember(pairs, [idx_row_A, idx_col_A], 'rows') | ismember(pairs, [idx_col_A, idx_row_A], 'rows'));
ds_A.chanPairs = pairs(idx_pairs_A, :);
ds_A.connectStrength = A_fc_avg(sub2ind([channel_number, channel_number], idx_row_A, idx_col_A));
ds_A.connectStrengthLimits = [threshold max(A_fc_avg(:))];
figure; title([name1 ' (Thresholded)']); topoplot_connect_1(ds_A, chanlocs);
% Filtering and mapping the second condition
[idx_row_B, idx_col_B] = find(triu(B_fc_avg, 1) > threshold); 
idx_pairs_B = find(ismember(pairs, [idx_row_B, idx_col_B], 'rows') | ismember(pairs, [idx_col_B, idx_row_B], 'rows'));
ds_B.chanPairs = pairs(idx_pairs_B, :);
ds_B.connectStrength = B_fc_avg(sub2ind([channel_number, channel_number], idx_row_B, idx_col_B));
ds_B.connectStrengthLimits = [threshold max(B_fc_avg(:))];
figure; title([name2 ' (Thresholded)']); topoplot_connect_1(ds_B, chanlocs);
