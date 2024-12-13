# mixed_reality_stereo_vision
A study on the characterization of stereoscopic visual fatigue induced by mixed reality environments. We focused on EEG and peripheral physiological signals. Specifically, We recorded 24-channel electroencephalogram (EEG) signals from 23 healthy participants and combined them with electrocardiogram (ECG), galvanic skin response (GSR), peripheral oxygen saturation (SpO2), respiratory, and skin temperature data from 13 participants. These physical signal characteristics were extracted and combined into corpus. Among them, EEG signals are recorded through [the NeuSen W wireless EEG acquisition system](http://www.neuracle.cn/), peripheral physiological signals are collected by [the ErgoLAB intelligent wearable sensors](https://resources.ergolab.cn/), and visual stimuli are presented through [Microsoft HoloLens2](https://www.insight.com/en_US/shop/partner/microsoft/hardware/hololens.html).
 ![image](https://github.com/taochunguang2022/mixed_reality_stereo_vision/blob/main/device.jpg)
## EEG pre-processing procedure
The "resting_state_eeg" folder represents the preprocessed EEG data from 23 participants. The specific preprocessing steps are outlined below:
 ![image](https://github.com/taochunguang2022/mixed_reality_stereo_vision/blob/main/data_preprocessing.jpg)
- Load the original data
  - In the raw EEG data pre-processing procedure, eeglab2021.1 was used to read the original Neuracle EEG data and was used to organize the data into BIDS format. The full BIDS format of raw EEG dataset is publicly accessible via the [Openneuro platform](https://openneuro.org/datasets/ds005416}{https://openneuro.org/datasets/ds005416)
- Channel location
  - Select channel range
- Filtering
  - The EEG data were bandpass filtered (0.5-30 Hz) and 50 Hz notch filtered
- Data segmentation
  - EEG = eeg_regepochs(EEG,'recurrence',2,'limits',[0 2],'rmbase',NaN); eeglab redraw
- Manual inspection
  - Plot->channel data(scroll); Seeking the bad channels and epochs
- Run ICA
  - An Independent Component Analysis (ICA) algorithm was run to isolate independent components in the data, which were then combined with the ICLABEL toolkit to identify and remove artefacts 
- Auto find abnormal values
  - Abnormal values were identified to remove epochs with amplitudes exceeding ±100 µV
- Average re-referencing
  - Data from all channels were used to calculate a common average reference
## Brain Network Construction
After preprocessing the EEG signals, brain networks were constructed using a Phase-Locked Value (PLV) method. The specific details are as follows: First, the preprocessed EEG recordings were band-pass filtered with delta (0.5–4 Hz), theta (4–8 Hz), and alpha (8–13 Hz) frequency bands. Second, the PLV matrix was calculated, which consisted of the functional connectivity between all possible electrode pairs. Third, the brain network was constructed based on the calculated PLV matrix by applying an appropriate threshold T. Finally, topological characteristics were calculated from the constructed brain networks between comfort and fatigue states. The "code_eeg_characteristic" folder mainly include related code above mentioned. Specifically, as follows:
- compute_rest_fc script
  - This script computes the phase-locking value (PLV) within specific frequency bands: delta (0.5-4Hz), theta (4-8Hz), and alpha (8-13Hz). It utilizes the Hilbert transform to calculate the phase differences between channel pairs, drawing data from both "comfort" and "uncomfort" conditions. Subsequently, it averages the PLV across different epochs. The outcomes for both individual and group analyses are saved in a .mat file, which bears a specific prefix and the name of the corresponding frequency band. For further reference, please consult the "calculated_plv" folder.
