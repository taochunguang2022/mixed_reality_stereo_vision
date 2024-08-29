clear all; close all; clc

%% Specify relevant information
Data_Dir = uigetdir([],'Path of the EEG datasets'); 
Output_Dir = uigetdir([],'Path to store the measures');

band = inputdlg('the limits of band');
band = str2num(band{1}); 

bandname = inputdlg('the name of the band you computed'); 
bandname = bandname{1};

prefix = inputdlg('the prefix of computed measures');
prefix = prefix{1};

%% Get the set file contained in the EEG data path
Dir_Data = dir(fullfile(Data_Dir,'*.set')); 
FileNames = {Dir_Data.name};


%% 2nd  (phase-locking value )   
for subj = 1:numel(FileNames)
    EEG = pop_loadset('filename',FileNames{1,subj},'filepath',Data_Dir);
    EEG = eeg_checkset( EEG ); 
    eeg_filtered = eegfilt(reshape(EEG.data, [size(EEG.data,1) size(EEG.data,2)*size(EEG.data,3)]),
                   EEG.srate,band(1,1),band(1,2),0,3*fix(EEG.srate/band(1,1)),0,'fir1',0); 
         
    for channels = 1:size(EEG.data,1)
        band_phase(channels,:) = angle(hilbert(eeg_filtered(channels,:))); 
    end    
    perc10w =  floor(size(band_phase,2)*0.1);
    band_phase = band_phase(:,perc10w+1:end-perc10w); 
    epoch_num = floor(size(band_phase,2)/size(EEG.data,2)); 
    band_phase = band_phase(:,1:epoch_num*size(EEG.data,2)); 
    band_phase = reshape(band_phase,[size(EEG.data,1) size(EEG.data,2) epoch_num]);
    
    for x = 1:size(band_phase,1)
         for y = 1:size(band_phase,1)
             for epochs = 1:size(band_phase,3)
                 x_phase = squeeze(band_phase(x,:,epochs));
                 y_phase = squeeze(band_phase(y,:,epochs)); 
                 rp = x_phase - y_phase; 
                 sub_plv(x,y,epochs) = abs(sum(exp(1i*rp))/length(rp)); 
             end
         end
    end
   plv(:,:,subj) = mean(sub_plv,3); 
   clear band_phase sub_plv
end

save(strcat(Output_Dir,'\',prefix,'_',bandname,'_plv.mat'),'plv');


