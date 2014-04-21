## Readme file for:

Higuera, P.E. and P.V. Dunnette. 2014. Data, code, and figures from Dunnette et al. 2014, 
Biogeochemical impacts of wildfires over four millennia in a Rocky Mountain subalpine 
watershed. New Phytologist. Figshare. http://dx.doi.org/10.6084/m9.figshare.988687 **

## Code needed to recreate the analyses in:
Dunnette, P. V., P. E. Higuera, K. K. McLauchlan, K. M. Derr, C. E. Briles, and M. H. Keefe. 
2014. Biogeochemical impacts of wildfires over four millennia in a Rocky Mountain 
subalpine watershed. New Phytologist Accepted.**

The archive includes seven folders, with contents described below. Most data files are in .csv 
format; some are in .xls format. Scripts and functions are written for MATLAB software 
(www.mathworks.com), and each is fully commented, including dependencies. For some scripts 
or functions, the MATLAB statistics and curve fitting toolboxes are required; all other functions 
required are provided in this archive.
 
=========================================================
###CHICKAREE LAKE BIOGEOCHEMICAL DATA: CH10_biogeochemData.csv

Includes the following raw data (by column): 
1. core_ID: Sediment core identification number
2. drive_ID: Drive identifier 
3.	top_sam_#: Top sample number
4.	bot_sam_#: Bottom sample number 
5.	top_cm: Top depth of sample (cm)
6.	bot_cm: Bottom depth of sample (cm) 
7.	top_age: Top age of sample (cal. yr before CE 1950)
8.	bot_age: Bottom age of sample (cal. yr before CE 1950)
9.	d15N: Nitrogen isotopic composition (?15N; ‰) 
10.	%N: Percent Nitrogen (by weight)
11.	d13C: Carbon isotopic composition (?13C; ‰)
12.	%C: Percent Carbon (by weight)
13.	C:N_atomic_ratio: Ratio of %C to %N (atomic)
14.	bulk_density: Bulk density (dry g wet cm-3)
15.	C_acc: Carbon accumulation rate (g cm-2 yr-1)
16.	MS_SI : Magnetic susceptibility (SI units)

####   Missing Values: NaN

   Checksum values:
   CH10_biogeochemData.csv: 635 rows (with headers), 16 columns 
   Column 3 (top_sam_#): 58551
   Column 5 (top_cm): 201836
   Column 10 (%N): 626.83
   Column 15 (C_acc): 341.58 

=========================================================

**CHICKAREE LAKE BIOGENIC SILICA DATA: CH10_BSiData.csv**

Includes the following raw data (by column): 
1.	top_cm: top depth of sample (cm)
2.	bot_cm: bottom depth of sample (cm) 
3.	top_age: top age of sample (cal. yr before CE 1950)
4.	bot_age: bottom age of sample (cal. yr before CE 1950)
5.	%BSi: Percent biogenic silica (by weight) 
6.	d15NAIR: Nitrogen isotopic composition (?15N; ‰) 
7.	%N: Percent Nitrogen (by weight)
8.	d13CVPDB_17O_corrected: Carbon isotopic composition (?13C; ‰)
9.	%C: Percent Carbon (by weight)
10.	C:N_atomic_ratio: Ratio of %C to %N (atomic)
11.	bulk_density: Bulk density (dry g wet cm-3)

   Missing Values: None 

   Checksum values: 
   CH10_BSiData.csv: 41 rows (with headers), 11 columns 
   Column 3 (top_cm): 69935 
   Column 5 (%BSi): 1042.45
   Column 10 (C:N): 591.52


**CHICKAREE LAKE LOSS-ON-IGNITION DATA: CH10_LOI_Data.csv**

Includes the following raw data (by column): 
1.	core_ID: Sediment core identification number 
2.	drive_ID: Drive identifier 
3.	top_sam_#: Top sample number
4.	bot_sam_#: Bottom sample number 
5.	top_cm: top depth of sample (cm)
6.	bot_cm: bottom depth of sample (cm) 
7.	top_age: top age of sample (cal. yr before CE 1950)
8.	bot_age: bottom age of sample (cal. yr before CE 1950)
9.	d15N: Nitrogen isotopic composition (?15N; ‰) 
10.	%N: Percent nitrogen (by weight)
11.	d13C: Carbon isotopic composition (?13C; ‰)
12.	%C: Percent carbon (by weight)
13.	C:N_atomic_ratio: Ratio of %C to %N (atomic)
14.	bulk_density: Bulk density (dry g wet cm-3)
15.	LOI_550: Loss on ignition at 550 C (% organic matter; multiply by 100) 
16.	LOI_1000: Loss on ignition at 1000 C (% organic matter; multiply by 100) 

   Missing Values: None

   Checksum values: 
   CH10_LOI_Data.csv: 124 rows (with headers), 16 columns 
   Column 3 (top_samp_#): 12010
   Column 5 (top_cm): 31833.7
   Column 10 (%N): 161.05
   Column 15 (LOI_550): 38.63

=========================================================
**CHICKAREE LAKE CHARCOAL DATA: CH10_charData.csv, CH10_charParams.csv, 
CH10_charResults.csv**

Three files provide the raw input data, the parameters used, and the output data for charcoal 
analysis via the program CharAnalysis (see ‘Materials and Methods’ in main text, and web site 
https://sites.google.com/site/charanalysis/). 

CH10_charData.csv
Includes the following raw data (by column):
1.	cmTop: top depth (cm) of the sample
2.	cmBot: bottom depth (cm) of the sample
3.	ageTop (yr BP): estimated age at top of sample (cal. yr before CE 1950)
4.	ageBot (yr BP): estimated age at bottom of sample (cal. yr before CE 1950)
5.	charVol (cm3): volume of sediment subsample from which charcoal was prepared (cm3)
6.	charCount (#): pieces of charcoal counted in the sample (#)

   Missing values: None

   Checksum values:
   CH10_charData.csv: 1202 rows (with headers), 6 columns 
Column 3 (ageTop (yr BP)): 2446519 
Column 6 (charCount (#)): 38218
CH10_charParams.csv
See CharAnalysis User’s Guide for description of parameters file, available at the web 
site linked to above.
      Missing values: -9999 (column 3) or blank cell (all others)
      Checksum values: CH10_charParams.csv: 26 rows (with headers), 5 columns
      Column 3 (Parameters): -39779
 
CH10_charResults.csv
Includes the following derived data (reflecting interpolation): 
1.	cmTop_i: top depth (cm) of interpolated sample
2.	ageTop_i: bottom depth (cm) of interpolated sample
3.	charCount_i: pieces of charcoal in interpolated sample
4.	charVol_i: volume of interpolated sample
5.	charCon_i: charcoal concentration in interpolated sample (pieces/cm3)
6.	charAcc_i: charcoal accumulation rate, based in interpolated concentration and age 
(pieces/cm2*yr)
7.	charBkg: background charcoal, Cback, smoothed based on methods selected in 
*_charParams.csv file, (pieces/cm2*yr)
8.	charPeak: peak charcoal, Cpeak, based on methods selected in *_charParams.csv file, 
(pieces/cm2*yr)
9.	thresh1: threshold value (pieces/cm2*yr) based on first threshold entered in 
*_charParams.csv file
10.	thresh2: same as thresh1, but for second threshold entered
11.	thresh3: same as thresh1, but for third threshold entered
12.	threshFinalPos: positive threshold value (pieces/cm2*yr), based on fourth threshold 
value entered in *charParams.csv file
13.	threshFinalNeg: negative threshold value (pieces/cm2*yr), based on fourth threshold 
value entered in *charParams.csv file
14.	SNI: signal-to-noise index values, based on threshdFinalPos values
15.	threshGOF: P value from KS goodness-of-fit test between fitted noise distribution and 
empirical data below the sample-specific threshold
16.	peaks1: samples that exceed thresh1 values are identified by “1”; only the first sample is 
identified
17.	peaks2: same as peaks1, but for the second threshold value
18.	peaks3: same as peaks1, but for the third threshold value
19.	peaksFinal: same as peaks1, but for the final threshold value
20.	peaksInsig.: peaks that exceeded threshFinalPos (the final threshold), but did not pass 
the minimum-count test are identified with a “1”
21.	peakMag: peak magnitude is the total pieces of charcoal accumulated in a given peak 
(pieces/cm2*peak); if a peak is only one sample long, then peak magnitude is simply 
CHAR minus the positive threshold. If a peak is more than one sample long, then each 
sample exceeding threshFinal is summed
22.	smPeak Frequ (peaks 1ka-1): frequency of peaks (from peaksFinal) smoothed over time, 
as set in *_charParams.csv file
23.	smFRIs (yr*fire-1): fire return intervals (from peaksFinal) smoothed over time, as set in 
*_charParams.csv file 
   Missing values: NaN

   Checksum values:
   CH10_charResults.csv: 458 rows (with headers), 23 columns 
Column 2 (age Top_i): 1014540 
Column 6 (char Acc_i): 753.8938 
Column 19 (peaks Final): 36


=========================================================
**CHICKAREE LAKE MAGNETIC SUSCEPTIBILITY DATA: CH10_MS_charData.csv, 
CH10_MS_charParams.csv, CH10_MS_charResults.csv**

Three files provide the raw input data, the parameters used, and the output data for peak 
analysis of magnetic susceptibility (MS) data, using the program CharAnalysis (see ‘Materials 
and Methods’ in main text, and web site https://sites.google.com/site/charanalysis/). The 
column headers for all files are the same as for charcoal analysis (CH10_char* files), but NOTE 
that the units for MS have been manipulated to be able to be used in CharAnalysis (see 7-9 
below). 

CH10_MS_charData.csv

Includes the following raw data (by column):
1.	cmTop: top depth (cm) of the sample
2.	cmBot: bottom depth (cm) of the sample
3.	ageTop (yr BP): estimated age at top of sample (cal. yr before CE 1950)
4.	ageBot (yr BP): estimated age at bottom of sample (cal. yr before CE 1950)
5.	dummyVar: dummy variable set to 1, to facilitate use in CharAnalysis program
6.	MS_shifted_trans: Shifted MS data (from col. 8), transformed by dividing by the 
sediment accumulation rate (cm/yr). Thus, when these transformed values are multiplied 
by the sediment accumulation rate (cm/yr), as done in CharAnalysis, the result is the 
transformed MS values (column 8).
7.	MS_raw_SI: Raw magnetic susceptibility measurements (SI units) 
8.	MS_shifted: Raw MS values, shifted by adding the minimum values in MS_raw_SI to 
each value, such that the minimum value becomes 0. CharAnalysis cannot work with 
negative data. 

   Missing values: None

   Checksum values:
   CH10_MS_charData.csv: 1477 rows (with headers), 8 columns 
Column 3 (ageTop (yr BP)): 3970165 
Column 6 (setRate/MS): 0.3626761

=========================================================
CHICKAREE LAKE CHRONOLOGY DATA: CH10_210Pb_data.xls, 
CH10_ageDepthData.xls, CH10_ageDepthData.csv, CH10_radiometricSamples.csv, and 
CH10_14Cdates.zip.

These files provide the chronology data presented in Table S1 (CH10_radiometricSamples.csv), 
the age-depth data presented in Figure 2 (CH10_ageDepthData.csv), and the input files used in 
the MATLAB functions CRSModel.m and MCAgeDepth.m (*.xls), publically available at 
http://code.google.com/p/crsmodel/ and http://code.google.com/p/mcagedepth/, as used in 
Higuera et al. (2009, Ecological Monographs, 79:201–219). See the user manuals for each 
program at these web sites for details on the two .xls files. The .zip archive includes the .B00 
files output from CALIB (see Materials and Methods in main text) and needed to run 
MCAgeDepth. The age-depth data output from MCAgeDepth is described below.

CH10_ageDepthData.csv

Includes the following raw data (by column):
1.	Top depth of sample (cm)
2.	Calibrated age at sample top (cal yr BP)
3.	Upper 95% confidence intervals for data in column two
4.	Lower 95% confidence intervals for data in column two
5.	Sedimentation rate (cm/yr)
6.	Upper 95% confidence intervals for data in column five
7.	Lower 95% confidence intervals for data in column five
8.	Sample resolution (yr/sample)
9.	Upper 95% confidence intervals for data in column eight
10.	Lower 95% confidence intervals for data in column eight

   Missing values: None

   Checksum values: CH10_AgeDepthData.csv: 1596 rows (with headers), 10 columns 
Column 1 (sampleCm): 642150.9 
Column 2 (calAge): 4679522	 
Column 5 (sedAcc): 211.236 
Column 8 (sampleRes): 6860.85

=========================================================

CHICKAREE LAKE POLLEN DATA: CH10_PollenCounts.xls, CH10_pollenPercentages.csv.

Raw pollen data needed to use in the function pollenDiagram_ROMO.m, to create Fig. S2 
(*.xls), and pollen percentages (*.csv). 

 CH10_PollenCounts.xls

Includes the following raw data (by column):
1.	Sample_ID : Identification of sample, by lake (CH), year (07 or 10), core (1 or 2), and 
drive (A, B, C…).
2.	Sample_number: Sample number for each drive
3.	Top_cm: Top depth of each sample (cm)
4.	age_yrBP: Age of each sample, in calibrated years before present (CE 1950)
5.	Pinus hap: Haploxilon Pinus pollen grains counted
6.	Pinud dip: Diploxilon Pinus pollen grains counted
7.	Pinus undiff: Undifferentiated Pinus pollen grains counted
8.	Picea: Picea pollen grains counted
9…112: Columns heads are the taxonomic identification for each pollen grain counted
111. Charcoal: NOT COUNTED
112.  EU: Exotic pollen grains, added as spike. 	

   Missing values: NaN.

   Checksum values: CH10_PollenData.xls: 46 rows (with headers), 113 columns 
Column 2 (sample_number): 6143 
Column 4 (age_yrBP): 86683	 
Column 10 (Pseudotsuga/Larix): 42 
Column 113 (EU): 8793


CH10_pollenpercentages.csv

Includes the following raw data (by column):
1.	Sample_ID : Identification of sample, by lake (CH), year (07 or 10), core (1 or 2), and 
drive (A, B, C…).
2.	Sample_number: Sample number for each drive
3.	Top_cm: Top depth of each sample (cm)
4.	age_yrBP: Age of each sample, in calibrated years before present (CE 1950)
5.	Pinus hap: Haploxilon Pinus pollen grains counted
6.	Pinud dip: Diploxilon Pinus pollen grains counted
7.	Pinus undiff: Undifferentiated Pinus pollen grains counted
8.	Picea: Picea pollen grains counted
9…107: Columns heads are the taxonomic identification for each pollen grain counted

   Missing values: None.

   Checksum values: CH10_PollenData.xls: 46 rows (with headers), 106 columns 
Column 2 (sample_number): 6143 
Column 4 (age_yrBP): 86683	 
Column 10 (Pseudotsuga/Larix): 12 
Column 102 (Nuphar): 13.19