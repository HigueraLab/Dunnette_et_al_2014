Higuera, P.E. and P.V. Dunnette. 2014. Data, code, and figures from Dunnette et al. 2014, 
Biogeochemical impacts of wildfires over four millennia in a Rocky Mountain subalpine 
watershed. New Phytologist. Figshare. http://dx.doi.org/10.6084/m9.figshare.988687 
===================
Code needed to recreate the analyses in Dunnette et al. 2014:
Dunnette, P. V., P. E. Higuera, K. K. McLauchlan, K. M. Derr, C. E. Briles, and M. H. Keefe. 
2014. Biogeochemical impacts of wildfires over four millennia in a Rocky Mountain 
subalpine watershed. New Phytologist Accepted.

The entire archive includes seven folders, with contents described below. Most data files are in 
.csv format, while some are in .xls format. The scripts to generate the figures for use in 
MATLAB software, and each script or function is fully commented, including dependencies. 
For some scripts, the statistics and curve fitting toolboxes are required; all other functions 
required are provided. 
===================
CH10_biogeochem
	CH10_biogeochemData.csv
	CH10_BSiData.csv
	CH10_LOI_data.csv

===================
CH10_charcoal
	CH10_charData.csv
	CH10_charParams.csv
	CH10_charResults.csv
Three files provide the raw input data, the parameters used, and the output data for charcoal 
analysis via the program CharAnalysis (see ‘Materials and Methods’ in main text). 
Missing values denoted by -9999 (*_charParams.csv) or NaN (*_charResults.csv).
CH10_charData.csv includes the following raw data (by column):
1.	cmTop: top depth (cm) of the sample
2.	cmBot: bottom depth (cm) of the sample
3.	ageTop: estimated age at top of sample (cal. yr before CE 1950)
4.	ageBot: estimated age at bottom of sample (cal. yr before CE 1950)
5.	charVol: volume of sediment subsample from which charcoal was prepared (cm3)
6.	charCount: pieces of charcoal counted in the sample (#)
Checksum values:
CH10_charData.csv: 1202 rows (with headers), 6 columns 
Column 3 (ageTop (yr BP)):  
Column 6 (charCount (#)): 

===================
CH10_chronology
CH10_ageDepthData.csv
Each file contains the output data from the program MCAgeDepth (Higuera et al. 2009, 
Ecological Monographs, 79:201–219), used to create Fig. 2 in the main text. 
Columns are as follows:
1.	Top depth of sample [cm]
2.	Calibrated age at sample top [cal yr BP]
3.	Upper 95% confidence intervals for data in column two.
4.	Lower 95% confidence intervals for data in column two.
5.	Sedimentation rate [cm/yr]
6.	Upper 95% confidence intervals for data in column five.
7.	Lower 95% confidence intervals for data in column five.
8.	Sample resolution [yr/sample]
9.	Upper 95% confidence intervals for data in column eight.
10.	Lower 95% confidence intervals for data in column eight.
Missing values: none.
Checksum values:
CH10_AgeDepthData.csv: 1596 rows (with headers), 10 columns 
Column 1 (sampleCm): 642150.9 
Column 2 (calAge): 4679522	 
Column 5 (sedAcc): 211.236 
Column 8 (sampleRes): 6860.85





