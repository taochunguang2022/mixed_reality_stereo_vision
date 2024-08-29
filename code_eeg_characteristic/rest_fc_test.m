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
A_fc  = importdata(strcat(pathname1,filename1)); 
B_fc  = importdata(strcat(pathname2,filename2)); 

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

AB_fc_avg2 = [A_fc_avg2; B_fc_avg2];

ds.chanPairs = pairs;  
ds.connectStrength = A_fc_avg2; 
ds.connectStrengthLimits = [min(AB_fc_avg2) max(AB_fc_avg2)];
figure;title(name1);topoplot_connect_pre(ds, chanlocs); 

ds.chanPairs = pairs;  
ds.connectStrength = B_fc_avg2; 
ds.connectStrengthLimits = [min(AB_fc_avg2) max(AB_fc_avg2)];
figure;title(name2);topoplot_connect_pre(ds, chanlocs); 

%% Statistical analysis between two conditions (or groups)
for  i = 1:fc_number   
    A_fc_2(i,:) = A_fc(pairs(i,1),pairs(i,2),:);
    B_fc_2(i,:) = B_fc(pairs(i,1),pairs(i,2),:);
end

if test_type == 1 
    for i = 1:fc_number 
       [~,p_right(i,1)] = ttest(A_fc_2(i,:),B_fc_2(i,:),0.05,'right');
       [~,p_left(i,1)] = ttest(A_fc_2(i,:),B_fc_2(i,:),0.05,'left');
       [~,p_both(i,1)] = ttest(A_fc_2(i,:),B_fc_2(i,:));
    end
else  
    for i = 1:fc_number 
       [~,p_right(i,1)] = ttest2(A_fc_2(i,:),B_fc_2(i,:),0.05,'right');
       [~,p_left(i,1)] = ttest2(A_fc_2(i,:),B_fc_2(i,:),0.05,'left');
       [~,p_both(i,1)] = ttest2(A_fc_2(i,:),B_fc_2(i,:));
    end
end
[~,h_right] = fdr(p_right,0.05);
idx_right = find(h_right == 1);
[~,h_left] = fdr(p_left,0.05);
idx_left = find(h_left == 1);
[~,h_both] = fdr(p_both,0.05); 
idx_both = find(h_both == 1);

ds_right.chanPairs = pairs(idx_right,:); 
ds_right.connectStrength = h_right(idx_right,1);
ds_right.connectStrengthLimits = [0 1];
figure;title(strcat('significant pairs: ',name1,'>',name2));
topoplot_connect_1(ds_right, chanlocs);

ds_left.chanPairs = pairs(idx_left,:); 
ds_left.connectStrength = h_left(idx_left,1);
ds_left.connectStrengthLimits = [0 1];
figure;title(strcat('significant pairs: ',name1,'<',name2));
topoplot_connect_1(ds_left, chanlocs);

ds_both.chanPairs = pairs(idx_both,:); 
ds_both.connectStrength = p_both(idx_both,1);
ds_both.connectStrengthLimits = [0 1];
figure;title(strcat('significant pairs: ',name1,' vs ',name2));       
topoplot_connect_1(ds_both, chanlocs);




    








