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
  - This script computes the phase-locking value within delta (0.5-4Hz), theta (4-8Hz), and alpha (8-13Hz) frequency band. It calculates the phase differences between channel pairs using the Hilbert transform from the "comfort" and "uncomfort" conditions, and averages PLV across epochs. The results of individual and group are saved as a .mat file with a specific prefix and band name. Please see the "calculated_plv" folder.
- rest_fc_test script
  - This script performs statistical analysis on functional connectivity measures between two conditions (comfort vs uncomfort) based on the calculated_plv folder. Statistical testing (this study selected paired t-tests) is conducted for each functional connection to identify significant differences. False discovery rate (FDR) correction is applied to control for multiple comparisons. Significant connections are visualized in separate plots, highlighting differences between conditions.
- single_subject script
  - This script visualizes the connectivity patterns for each condition using topographic plots by applying a specified threshold. This analysis can be conducted using paired t-tests. The choice of threshold is currently no definitive criterion. This study calculated the top 20% of PLV values for each participant across the alpha, theta, and delta frequency bands under comfort and uncomfort conditions. Finally, the threshold interval is 0.72 to 0.76 incrementally by 0.01 steps.
 - topoplot_connect_1 script
   - This script was utilized for the purpose of visualizing topographic plots
 - c1-5 scripts
   - These scrpts mainly calculate topological properties based on constructed brain networks. Node properties include betweenness centrality (BC), clustering coefficient (CC), and node efficiency (NE), and edge properties include characteristic path lengths (CPL) . Please see details in these scripts.
## Brain Network DataSet
For the graph dataset presented as a .csv format file, each graph structure contains 24 nodes, each with three node properties (BC, CC, NE). The adjacency matrix of each graph represents the network structure of the graph at a specific threshold. Each edge in each graph has a corresponding edge property (CPL). Finally, labels (“comfort” and “fatigue”) were assigned to each graph structure in preparation for subsequent classification using the graph neural network (GNN) model.
### General Descriptors
 - sessionId
   - a unique graph structure
 - nodeId
   - Fp1 (1), Fp2 (2), AF3 (3), AF4 (4), Fz (5), F7 (6), F8 (7), FC5 (8), FC6 (9), FT7 (10), FT8 (11), Cz (12), C3 (13), C4 (14), CP3 (15), CP4 (16), Pz (17), P3 (18), P4 (19), PO3 (20), PO4 (21), Oz (22), O1 (23), O2 (24)
 - degree
   - betweenness centrality (BC)
 - cluster
   - clustering coefficient (CC)
 - efficiency
   - node efficiency (NE)
 - source/ target
   - The adjacency matrix
 - edge_feature
   - characteristic path lengths (CPL)
### Label Descriptor
 - 0: comfort
 - 1: fatigue
### Classification
 - GraphSAGE/ GINConv
   - They solely consider node features
 - GraphConv/ GATConv
   - They incorporate both node and edge features
### Model Visualization
   Taking GraphSAGE and GraphConv models as examples:
   ![image](https://github.com/taochunguang2022/mixed_reality_stereo_vision/blob/main/code_classification.jpg)
## Peripheral physiological signals pre-processing procedure
   

