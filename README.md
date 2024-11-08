# BudgieAAC

Code for the budgie AAC project.

## System requirements

All code was tested on Matlab 2023a running on Windows 10.

### Dependencies

- 200 colormap: https://www.mathworks.com/matlabcentral/fileexchange/120088-200-colormap
- DataViz: https://github.com/povilaskarvelis/DataViz
- mseb: https://www.mathworks.com/matlabcentral/fileexchange/47950-mseb-x-y-errbar-lineprops-transparent
- arrow: https://www.mathworks.com/matlabcentral/fileexchange/278-arrow
- cumstom colormap: https://www.mathworks.com/matlabcentral/fileexchange/42450-custom-colormap
- venn: https://www.mathworks.com/matlabcentral/fileexchange/22282-venn

## Instructions

1. Copy all code files into a local folder.
2. Download the dataset from Zenodo and save it in the same folder.
3. Create a subfolder named `Paper` for saving figures.

The file `publish.m` contains code to generate/reproduce figures and results in the manuscript. The total runtime will vary depending on your PC specifications, but it should benerally be within several hours. 

To reduce processing time, computationally intensive processes (e.g., permutation analyses) have been commented out. If desired, these sections can be uncommented to rerun the corresponding analyses.

## Major code files description

- `publish.m`: Generates figures, performs statistical tests and analyses not covered by other files. 
- `Fig1_step1_getData_bg.m` and `Fig1_step1_getData_zf.m`: Characterize neural responses to vocal and nonvocal conditions. 
- `Fig2_step1_getData_bg.m` and `Fig2_step1_getData_zf.m`: Calculate neural responses to vocal segments used in similarity analyses.
- `Fig2_step1_getData_getPiecewiseAnalysisData_BgAndZf.m`: Calculate neural and spectral similarity between vocal segments.
- `Fig3_step1_getData_bg.m` and `Fig3_step1_getData_zf.m`: Compute neural responses to each vocal time point at 1 ms resolution and perform PCA.

## Dataset documentation

The dataset is available on Zenodo: (https://)

### Budgerigar data

Data for individual budgerigars are stored in separte folders, each representing a single individual:
- Bl122_ChronicLeftAAC
- Li145_ChronicLeftAAC
- Or61_ChronicLeftAAC
- Ti81_ChronicLeftAAC

Within each folder:
 
- `sua.mat` contains spikes times
- `audioCh3_HP.flac` contains vocal recordings from the piezoelectric mic.

### Zebra finch data
Zebra finch data are stored in the `ZF` folder.

### Generated data files
Below is a description of other major data files generated during the analysis:

- `bgResp.mat` and `zfResp.mat`: Contain characterization of basic neural responses, including firing rates to vocalization, baseline, playback.
- `bgFrSpec.mat`,`zfFrSpec.mat`, and `bgzfpiecewisecorr_bgAllSy.mat`: Contain neural responses to vocal segments, as well as neural and spectral similarity measures for these segments.
- `bgPitch.mat` and `zfPitch.mat`: Contain neural responses to vocal time points at 1 ms resolution, along with pitch estimations for each vocalization.
