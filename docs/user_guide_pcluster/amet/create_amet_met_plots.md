## Test AMET Met Website 

Change the IP address to the public IP address for your instance in this example.

```
http://[your-ec2-external-ip-address]:443/querygen_met.php
```

Users select the database, project, variables to plot, and plotting programs.
The following pull-down lists the available plotting programs.


## Programs to create plots
<details>
  <summary>Scatter Plots (13) | Click to expand!</summary>
<ol> Name of R Script | Select Program 
    <li>AQ_Scatterplot.R  | Multiple Networks Model/Ob Scatterplot (select stats only)</li>
   <li> AQ_Scatterplot_ggplot.R | GGPlot Scatterplot (multi network, single run)</li>
   <li> AQ_Scatterplot_plotly.R | Interactive Multiple Network Scatterplot</li>
    <li>AQ_Scatterplot_multisim_plotly.R | Interactive Multiple Simulation Scatterplot</li>
    <li>AQ_Scatterplot_single.R | Single Network Model/Ob Scatterplot (includes all stats)</li>
    <li>AQ_Scatterplot_density.R | Density Scatterplot (single run, single network)</li>
    <li>AQ_Scatterplot_density_ggplot.R | GGPlot Density Scatterplot (single run, single network)</li>
    <li>AQ_Scatterplot_mtom.R | Model/Model Scatterplot (multiple networks)</li>
    <li>AQ_Scatterplot_mtom_density_ggplot.R | Model/Model Density Scatterplot (single network)</li>
    <li>AQ_Scatterplot_percentiles.R | Scatterplot of Percentiles (single network, single run)</li>
    <li>AQ_Scatterplot_bins.R | Binned MB & RMSE Scatterplots (single net., mult. run)</li>
    <li>AQ_Scatterplot_bins_plotly.R | nteractive Binned Plot (single net., mult. run)</li>
    <li>AQ_Scatterplot_multi.R | Multi Simulation Scatter plot (single network, mult runs)</li>
</ol>
</details>

<details>
  <summary>Timeseries Plots (12) |  Click to expand!</summary>
<ol>Name of R Script | Program 
   <li> AQ_Timeseries.R | Time-series Plot (single network, multiple sites averaged)</li>
    <li>AQ_Timeseries_bysite.R | Individual Site Time-series Plots (single network, multiple sites not average)</li>
    <li>AQ_Timeseries_dygraph.R | Dygraph Time-series Plot (single network, multiple sites averaged)</li>
    <li>AQ_Timeseries_plotly.R | Plotly Muli-simulation Timeseries</li>
    <li>AQ_Timeseries_plotly_bysite.R | Individual Site Plotly Time-series Plots (single network, multiple sites not average)</li>
    <li>AQ_Timeseries_networks_plotly.R | Plotly Multi-network Timeseries</li>
    <li>AQ_Timeseries_species_plotly.R | Plotly Multi-species Timeseries</li>
    <li>AQ_Timeseries_multi_networks.R | Multi-Network Time-series Plot (mult. net., single run)</li>
    <li>AQ_Timeseries_multi_species.R | Multi-Species Time-series Plot (mult. species, single run)</li>
    <li>AQ_Timeseries_MtoM.R | Model-to-Model Time-series Plot (single net., multi run)</li>
    <li>AQ_Monthly_Stat_Plot.R | Year-long Monthly Statistics Plot (single network)</li>
    <li>AQ_Monthly_Stat_Plot_plotly.R | Interactive Year-long Monthly Statistics Plot (single network)</li>
</ol>
</details>
<details>
  <summary>Spatial Plots (13) | Click to expand!</summary>
<ol>Name of R Script | Program  
   <li>AQ_Stats_Plots.R | Species Statistics and Spatial Plots (multi networks)</li>
   <li> AQ_Stats_Plots_leaflet.R | Interactive Species Statistics and Spatial Plots (single plot)</li>
   <li> AQ_Stats_Plots_leaflet_network.R | Interactive Species Statistics and Spatial Plots (multiple plots)</li>
   <li> AQ_Plot_Spatial.R | Spatial Plot (multi networks)</li>
   <li> AQ_Plot_Spatial_leaflet.R | Interactive Spatial Plot</li>
  <li>  AQ_Plot_Spatial_leaflet_network.R | Interactive Spatial Plot (multiple plots)</li>
   <li> AQ_Plot_Spatial_Species_Diff_leaflet.R | Interactive Species Diff Spatial Plot (multi networks,multi species)</li>
    <li>AQ_Plot_Spatial_MtoM.R | Model/Model Diff Spatial Plot (multi network, multi run)</li>
    <li>AQ_Plot_Spatial_MtoM_leaflet.R | Interactive Model/Model Diff Spatial Plot (multi network, multi run)</li>
    <li>AQ_Plot_Spatial_MtoM_Species.R | Model/Model Species Diff Spatial Plot (multi network, multi run)</li>
    <li>AQ_Plot_Spatial_Diff.R | Spatial Plot of Bias/Error Difference (multi network, multi run)</li>
    <li>AQ_Plot_Spatial_Diff_leaflet.R | Interactive Spatial Plot of Bias/Error Difference (single plot)</li>
    <li>AQ_Plot_Spatial_Diff_leaflet_network.R | Interactive Spatial Plot of Bias/Error Difference (multiple plots)</li>
</ol>
</details>

<details>
  <summary>Box Plots (7) | Click to expand!</summary>
<ol>Name of R Script | Program  
   <li> AQ_Boxplot.R | Boxplot (single network, multi run)</li>
    <li>AQ_Boxplot_ggplot.R | GGPlot Boxplot (single network, multi run)</li>
    <li>AQ_Boxplot_plotly.R | Plotly Boxplot (single network, multi run)</li>
    <li>AQ_Boxplot_DofW.R | Day of Week Boxplot (single network, multiple runs)</li>
    <li>AQ_Boxplot_Hourly.R | Hourly Boxplot (single network, multiple runs)</li>
    <li>AQ_Boxplot_MDA8.R | 8hr Average Boxplot (single network, hourly data, can be slow)</li>
    <li>AQ_Boxplot_Roselle.R | Roselle Boxplot (single network, multiple simulations)</li>
</ol>
</details>

<details>
  <summary>Misc Plots (14) | Click to expand!</summary>
<ol>Name of R Script | Program  
    <li>AQ_Kellyplot.R | Kelly Plot (single species, single network, full year data)</li>
    <li>AQ_Kellyplot_plotly.R | Plotly Kelly Plot (single species, single network, full year data)</li>
    <li>AQ_Kellyplot_region.R | Climate Region Kelly Plot (single species, single network, multi sim)</li>
    <li>AQ_Kellyplot_region_plotly.R | Plolty Climate Region Kelly Plot (single species, single network, multi sim)</li>
    <li>AQ_Kellyplot_season.R | Seasonal Kelly Plot (single species, single network, multi sim)</li>
    <li>AQ_Kellyplot_season_plotly.R | Plotly Seasonal Kelly Plot (single species, single network, multi sim)</li>
    <li>AQ_Stats.R | Species Statistics (multi species, single network)</li>
    <li>AQ_Raw_Data.R | Create raw data csv file (single network, single simulation)</li>
    <li>AQ_Soccerplot.R | Soccergoal" plot (multiple networks)</li>
    <li>AQ_Soccerplot_plotly.R | Plotly "Soccergoal" plot (multiple networks/species)</li>
    <li>AQ_Bugleplot.R | "Bugle" plot (multiple networks)</li>
    <li>AQ_Histogram.R | Histogram (single network/species only)</li>
    <li>AQ_Histogram_plotly.R | Interactive Histogram (single network, single species, multi run)</li>
    <li>AQ_Temporal_Plots.R | CDF, Q-Q, Taylor Plots (single network, multi run)</li>
</ol>
</details>

<details>
  <summary>Experimental Scripts (13) | Click to expand!</summary>
<ol>Name of R Script | Program (may not work correctly) 
    <li>AQ_Overlay_File.R | Create PAVE/VERDI Obs Overlay File (hourly/daily data only)</li>
    <li>AQ_Scatterplot_log.R | Log-Log Model/Ob Scatterplot (multiple networks)</li>
    <li>AQ_Spectral_Analysis.R | Spectral Analysis (single network, single run, experimental)</li>
</ol>
</details>

### Met Observation Networks

<details>
<summary> Available Meteorology Observation Networks | Click to expand!</summary>
<ol>Meteorology Network (select METAR, not sure about other networks)
    <li>All</li>
    <li>METAR</li>
    <li>AIRNOW</li>
    <li>ASOS</li>
    <li>Maritime</li>
    <li>SAO</li>
    <li>Other-Mtr</li>
</ol>
</details>


## Example Meteorlogy Plot using AMET MET Website

### Create 2m Temperature Spatial Plots
<ul>
<li>Choose database</li>
  <ul>
    <li>select amet</li>
  </ul>
<li>Choose project 1
  <ul>
    <li>MetExample_wrf</li>
  </ul>
</li>
<li>Choose project 2
  <ul>
    <li>MetExample_mpas</li>
  </ul>
</li>
</ul>

![AMET Meteorology Website Select Database and Project](./met_plots/AMET_MET_website_choose_database_and_project.png)

<ul>
<li>Choose Met Variable</li>
  <ul>
    <li>select T(2m)</li>
  </ul>
</li>
</ul>


![AMET Meteorology Website Select Met Variable to use](./AMET_website_met_choose_variable_T.png)

<ul>
<li>Choose Program to Run</li>
  <ul>
    <li>select Species Statistics and Spatial Plot(multi networks)</li>
  </ul>
</li>
<li> Select Run Program</li>
</ul>


![AMET Website Select Plot and Run Program](./amet_website_run_programs.png)

<ul>
<li>Results of options selected in querygen_met.php</li>
</ul>

![AMET Website Result](./met_plots/amet_met_results_from_query_spatial.png)

<ul>
<li> 2m Temperature Normalized Mean Bias Plot</li>
</ul>

![AMET Normalized Mean Bias Spatial Plot of 2m Temperature](./met_plots/plot_met_metExample_wrf_T_NMB.png)

<ul>
<li>2m Temperature Normalized Mean Error Plot</li>
</ul>

![AMET Normalized Mean Error Spatial Plot](./met_plots/plot_met_metExample_wrf_T_NME.png)

<ul>
<li>2m Temperature Mean Bias Plot</li>
</ul>

![AMET Mean Bias Spatial Plot](./met_plots/plot_met_metExample_wrf_T_MB.png)

2m Temperature Mean Error Plot

![AMET Mean Error Spatial Plot](./met_plots/plot_met_metExample_wrf_T_ME.png)

2m Temperature Root Mean Square Error Plot

![AMET Mean Error Square Error Spatial Plot](./met_plots/plot_met_metExample_wrf_T_RMSE.png)

2m Temperature Correlation Plot

![AMET Correlation Spatial Plot](./met_plots/plot_met_metExample_wrf_T_Corr.png)

## Create Interactive 2M Temperature Spatial Plots

Under Met Variable to choose
Select T(2m)

Under Choose Program to Run
Select Interactive Spatial Plot (multiple plots)

![AMET Website Select Plot and Run Program](./met_plots/AMET_website_choose_interactive_spatial.png)

Results of options selected in querygen_met.php form

![AMET Website Result](./met_plots/AMET_website_result_query_T_2m_interactive_spatial.png)

Spatial Plot of 2m Temperature Observations

![Spatial Plot of 2m Temperature Observations](./met_plots/metExample_wrf_T_interactive_spatial_obs_plot.png)

Spatial Plot of 2m Temperature Model

![Spatial Plot of 2m Temperature Model](./met_plots/metExample_wrf_T_interactive_spatial_model_plot.png)

Spatial Plot of 2m Temperature Difference between Model and Observations

![Spatial Plot of 2m Temperature Differences](./met_plots/metExample_wrf_T_interactive_spatial_model_obs_diff_plot.png)


## Create Interactive 2M Temperature Model to Model Difference Spatial Plots

![AMET Website Select Plot and Run Program](./met_plots/AMET_website_choose_interactive_spatial_mtom_diff.png)

Results of options selected in querygen_met.php form

![AMET Website Result](./met_plots/AMET_website_result_query_T_2m_interactive_spatial_mtom_diff.png)

Spatial Plot of 2m Temperature Model to Model Average Difference Interactive Plot

![Spatial Plot of 2m Temperature Model to Model Average Difference Interactive Plot](./met_plots/metExample_wrf_T_spatialplot_mtom_diff_avg.png )

Spatial Plot of 2m Temperature Model to Model Maximum Difference Interactive Plot

![Spatial Plot of 2m Temperature Model to Model Max Diff Plot](./met_plots/metExample_wrf_T_spatialplot_mtom_diff_max.png)

Spatial Plot of 2m Temperature Model to Model Minimum Difference Interactive Plot

![Spatial Plot of 2m Temperature Model to Model Min Diff Plot](./met_plots/metExample_wrf_T_spatialplot_mtom_diff_min.png)

Spatial Plot of 2m Temperature Model to Model Difference Ratio Interactive Plot

![Spatial Plot of 2m Temperature Model to Model Diff Ratio Plot](./met_plots/metExample_wrf_T_spatialplot_mtom_diff_ratio.png)


## Create 2m Temperature Density Scatterplot

Under Met Variable to choose
Select T(2m)

Under Choose Program to Run
Select Density Scatterplot (single run, single network) 

![AMET Website Select Plot and Run Program](./met_plots/AMET_website_choose_density_scatterplot.png)

Results of options selected in querygen_met.php form

![AMET Website Result](./met_plots/AMET_website_result_query_T_2m_scatterplot.png)

Scatterplot of 2m Temperature

![Scatterplot of 2m Temperature](./met_plots/metExample_wrf_T_scatterplot_density.png)

## Create Timeseries Plot (single network, multiple sites averaged) for 2m Temperature

Under Met Variable to choose
Select T(2m)

Under Choose Program to Run
Timeseries Plot (single network, multiple sites averaged)

![AMET Website Select Plot and Run Program](./met_plots/amet_run_program_timeseries.png)

Results of options selected in querygen_met.php form

![AMET Website Result](./met_plots/AMET_website_result_query_T_2m_timeseries.png)

Timeseries Plot of 2m Temperature

![Timeseries plot of 2m Temperature](./met_plots/metExample_wrf_T_timeseries.png)


## Create Boxplot using METAR Met Observations and T(2m) Model Values

Under Met Observation Networks
Choose METAR

Under Met Variable to Use
Select T(2m)

![AMET Website Select Obs Network and Species](./amet_select_METAR_and_T2.png)

Under Choose Program to Run
Boxplot (single network, multi-run)

![Query Result](./amet_result_query_boxplot.png)

Boxplot of T2 all

![Boxplot of T2 all](./metExample_wrf_T_boxplot_all.png)

Boxplot of T2 Bias

![Boxplot of T2 Bias](./metExample_wrf_T_boxplot_bias.png)

Boxplot of T2 Normalized Bias

![Boxplot of T2 Normalized Bias](./metExample_wrf_T_boxplot_norm_bias.png)

## Create Plotly Boxplot using METAR Met Observations and T(2m) Model Values

Under Met Observation Networks
Choose METAR

Under Met Variable to Use
Select T(2m) 

![AMET Website Select Obs Network and Species](./amet_select_METAR_and_T2.png)

Under Choose Program to Run
Plotly Boxplot (single network, multi-run)

![Query Result](./amet_result_query_boxplot_plotly.png)

Plotly Boxplot of T2

![Plotly Boxplot of T2 ](./metExample_wrf_T_boxplot_plotly.png)

Note, the Bias and Normalized Bias Plots were not created successfully.

## Create Interactive Hourly Timeseries of T2 using Plotly

Under Met Observation Network
Select METAR

Under Met Species to Plot
Select T 

Under Choose Program to Run
Choose Plotly Multi-species Timeseries

![AMET run Plotly Multispecies Timeseries](./amet_run_plotly_multispecies_T_timeseries.png)

Note, this plot is interactive, and you can turn off items by clicking on an item in the legend, and also window to a specific time within the plot.

![Hourly Timeseries Plot of T](./amet_plotly_hourly_timeseries_multispecies_T.png)

## Create Bugle Plot

Under Observation Network
Select METAR

Under Met Species to Plot
Select T(2m)

![AMET select METAR ](./amet_select_METAR_T.png)

Under Choose Program to Run
Choose Bugle Plot(Multiple Networks) under Misc Scripts

![AMET run Bugle Plot](./amet_run_bugle_T.png)

Bugle Plot of Normalized Mean Bias (NMB) T for METAR Obs Network

![Bugle Plot of NMB Temperature](./amet_plot_bugle_T_Daily_METAR_NMB.png)

Bugle Plot of Normalized Mean Error (NME) Temperature for Networks METAR

![Bugle Plot of NMB Temp](./amet_plot_bugle_temp_metar_NME.png)


# Load your own data to MariaDB

## Prepare to load your own data

Load modules

Change to the c-shell

```
csh
```

Check modules available

```
module avail
```

Load Modules

```
module load ioapi-3.2/gcc-13.3  netcdf/gcc-13.3  openmpi/gcc  
```

Review directory set-up for files on /home/ubuntu

ls -lrt

```
total 48
drwxrwxr-x  3 ubuntu ubuntu 4096 Sep 23 16:43 Modules
drwxr-xr-x  3 ubuntu ubuntu 4096 Sep 23 18:15 aws
drwxrwxr-x 10 ubuntu ubuntu 4096 Sep 24 17:35 CMAQ55plus_REPO
drwxrwxr-x  8 ubuntu ubuntu 4096 Sep 24 17:52 CMAQv5.5+
drwx------  4 ubuntu ubuntu 4096 Sep 25 14:39 snap
drwxrwxr-x  3 ubuntu ubuntu 4096 Sep 25 17:17 MariaDB
drwxrwxrwx 15 ubuntu ubuntu 4096 Sep 25 19:30 AMET_v16
drwxrwxr-x  3 ubuntu ubuntu 4096 Sep 25 20:44 LIBRARIES
-rw-rw-r--  1 ubuntu ubuntu  467 Sep 29 17:25 ports.conf
-rw-rw-r--  1 ubuntu ubuntu 4962 Nov  3 15:22 branch_differences
-rw-rw-r--  1 ubuntu ubuntu  445 Nov  3 16:29 readme
```

Review directory set-up for files on /shared/AMET_v16

```
/shared/AMET_v16% ls -rlt */*
model_data/MET:
total 24
drwxrwxr-x 2 ubuntu ubuntu  4096 Sep 23 22:58 metExample_wrf
drwxrwxr-x 2 ubuntu ubuntu  4096 Sep 23 23:58 metExample_mpas
drwxrwxr-x 3 ubuntu ubuntu 12288 Sep 25 12:54 metExample_mcip

model_data/AQ:
total 4
drwxrwxr-x 2 ubuntu ubuntu   40 Nov  3 17:25 aqExample
```

Review size of data on /shared/AMET_v16 (note this is a 1 TB volume)

```
du -sh
768G
```

Review size of data on /home/ubuntu

```
du -sh
46G	.
```

Review size of the file systems available

```
df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root        290G   61G  230G  21% /
tmpfs            7.8G     0  7.8G   0% /dev/shm
tmpfs            3.1G  1.0M  3.1G   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  4.1K  119K   4% /sys/firmware/efi/efivars
/dev/nvme0n1p16  881M  151M  669M  19% /boot
/dev/nvme0n1p15  105M  6.2M   99M   6% /boot/efi
/dev/nvme1n1    1000G  787G  214G  79% /shared
tmpfs            1.6G   20K  1.6G   1% /run/user/1000
```

Note that AMET_Website is installed under /var/www/html

```
ls -rlt /var/www/html
ubuntu@ip-172-31-30-106:/var/www/html/cache$ ls -rlt /var/www/html
total 1128
-rw-rw-r-- 1 www-data www-data   4333 Sep 23 17:55 AMET_Species_Name_Mapping.txt
-rw-rw-r-- 1 www-data www-data    420 Sep 23 17:55 example_stat_file.txt
-rw-rw-r-- 1 www-data www-data   2283 Sep 23 17:55 disaq_4km_met_sites.txt
-rw-rw-r-- 1 www-data www-data    331 Sep 23 17:55 disaq_1km_met_sites.txt
-rw-rw-r-- 1 www-data www-data   2700 Sep 23 17:55 O3_NA_monitors_2018.txt
-rw-rw-r-- 1 www-data www-data   8434 Sep 23 17:55 O3_NAA_Sites_v2_short_names.txt
-rw-rw-r-- 1 www-data www-data   4257 Sep 23 17:55 O3_NAA_Sites_v2_no_names.txt
drwxrwxr-x 2 www-data www-data   4096 Sep 23 17:55 images
-rw-rw-r-- 1 www-data www-data   6475 Sep 23 17:55 run_info_met.template
-rw-r--r-- 1 www-data www-data  10671 Sep 25 18:41 index.html.back
-rw-rw-r-- 1 www-data www-data    286 Sep 25 19:47 index.html.sv
-rw-rw-r-- 1 www-data www-data   3861 Oct 10 17:10 amet-lib.php
-rwxrwxr-x 1 www-data www-data   2061 Oct 10 17:24 amet-config.R
-rw-rw-r-- 1 www-data www-data  11397 Oct 10 17:30 run_info.template
-rw-rw-r-- 1 www-data www-data   2084 Nov 19 16:12 amet-www-config.php
-rwxrwxr-x 1 ubuntu   ubuntu   362779 Dec 11 17:59 querygen_aq.php
-rwxrwxr-x 1 ubuntu   ubuntu   259959 Jan 14 18:08 querygen_met.php
drwxrwxrwx 8 www-data www-data 425984 Mar  1 18:46 cache
```

## Upload your own meteorology data

Change to the directory on /shared volume

```
cd /shared/AMET_v16/model_data/MET/ 
mkdir new_project
```

use the s3 cp command to upload your data

## Load your project data into the database

Create a new project under the script_db directory

```
cd ~/AMET_v16/scripts_db/
cp -rp metExample_wrf new_project
cd new_project
mv matching_raob.csh new_project_matching_raob.csh
```

Modify the project name in the script

```
vi new_project_matching_raob.csh

Change:
  setenv AMET_PROJECT    metExample_wrf
to:
  setenv AMET_PROJECT    new_project
```

Edit the run description

```
Change:
 setenv RUN_DESCRIPTION "WRF release test dataset."
to
 setenv RUN_DESCRIPTION "WRF new project dataset."
```

Edit the path to the wrf output, if that is what you are uploading for your new_project.

```
Change:
setenv METOUTPUT $AMETBASE/model_data/MET/$AMET_PROJECT/wrfout_subset
to 
setenv METOUTPUT $AMETBASE/model_data/MET/$AMET_PROJECT/wrfout_new_project
```

