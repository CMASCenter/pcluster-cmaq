# Spin up a server using pre-installed AMET AMI

 * Select AMI named AMETv1.6_web  that contains the AMETv1.6 installation with all data for MET and AQ loaded into database
 * Select Launch instance from AMI
 * Select Instance Type t3.xlarge (4vcpu and 16 GB memory) or t3.large (2 vcpu 8 GB memory)
 * Select key pair
 * Select existing security group - AMET_mysql
 * AMET_mysql security group contains permissions for port 443 and 3306 for inbound and outbound open to all or restricted to your IP address or you can add these permissions when you launch a new instance from the AMI.

![AMET Security Group](./amet_mysql_security_group_inbound_and_outbound_rules.png)

## Login to the EC2 instance

```
 ssh -Y -i ./<your_pem_name>.pem ubuntu@xx.xx.xx
```


Edit the apache2 ports.conf file to specify the private IP address for the EC2 instance that is being used to run AMETv1.6

sudo vi /etc/apache2/ports.conf

```
cat /etc/apache2/ports.conf 
```

Output:

```
### If you just change the port or add more ports here, you will likely also
### have to change the VirtualHost statement in
### /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 172.31.16.32:443
#Listen 3306

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443 
</IfModule>


<VirtualHost 172.31.16.32:443>

## This first-listed virtual host is also the default for *:80

ServerName http://localhost

DocumentRoot /var/www/html
</VirtualHost>
```

After the file is edited to use the private ip address, then restart the apache web server.

```
sudo systemctl restart apache2
```

## Start the mariadb

```
sudo systemctl start mariadb
```

## Check the version of mariadb that was installed

SELECT VERSION();
+-----------------------------------+
| VERSION()                         |
+-----------------------------------+
| 10.11.13-MariaDB-0ubuntu0.24.04.1 |


# Create Air Quality Plots using the AMET AQ Website

Verify connection to the web server querygen_aq.php

Change the IP address to the public IP address for your instance in this example.

```
http://[your-ec2-external-ip-address]:443/querygen_aq.php
```

Verify you see the website and that it looks similar to the image below.

# Programs to create plots
<details>
  <summary>Scatter Plots (14) | Click to expand!</summary>
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
    <li>AQ_Scatterplot_skill.R | Ozone Skill Scatterplot (single network, mult runs)</li>
    <li>AQ_Scatterplot_bins.R | Binned MB & RMSE Scatterplots (single net., mult. run)</li>
    <li>AQ_Scatterplot_bins_plotly.R | Interactive Binned Plot (single net., mult. run)</li>
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
  <summary>Spatial Plots (14) | Click to expand!</summary>
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
    <li>AQ_Plot_Spatial_Ratio.R | Ratio Spatial Plot to total PM2.5 (multi network, multi run)</li>
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
  <summary>Stacked Bar Plots (9) | Click to expand!</summary>
<ol>Name of R Script | Program
   <li> AQ_Stacked_Barplot.R | PM2.5 Stacked Bar Plot (CSN or IMPROVE, multi run)</li>
    <li>AQ_Stacked_Barplot_AE6.R | PM2.5 Stacked Bar Plot AE6 (CSN or IMPROVE, multi run)</li>
    <li>AQ_Stacked_Barplot_AE6_plotly.R | Interactive Stacked Bar Plot</li>
    <li>AQ_Stacked_Barplot_AE6_ggplot.R | GGPlot Stacked Bar Plot</li>
    <li>AQ_Stacked_Barplot_AE6_ts.R | Stacked Bar Plot Time Series</li>
    <li>AQ_Stacked_Barplot_soil_multi.R | Soil Stacked Bar Plot Multi (CSN and IMPROVE,single run)</li>
    <li>AQ_Stacked_Barplot_panel.R | Multi-Panel Stacked Bar Plot (full year data required)</li>
    <li>AQ_Stacked_Barplot_panel_AE6.R | Multi-Panel Stacked Bar Plot AE6 (full year data)</li>
    <li>AQ_Stacked_Barplot_panel_AE6_multi.R | Multi-Panel, Mulit Run Stacked Bar Plot AE6 (full year data)</li>
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
  <summary>Experimental Scripts (4) | Click to expand!</summary>
<ol>Name of R Script | Program (may not work correctly)
    <li>AQ_Overlay_File.R | Create PAVE/VERDI Obs Overlay File (hourly/daily data only)</li>
    <li>AQ_Scatterplot_log.R | Log-Log Model/Ob Scatterplot (multiple networks)</li>
    <li>AQ_Spectral_Analysis.R | Spectral Analysis (single network, single run, experimental)</li>
    <li>AQ_Plot_Spatial_Ratio.R | PM Ratio Spatial Plot (multi network, single run)</li>
</ol>
</details>




# Create PM2.5 Spatial Plots

Choose a Database:
Select amet 

Choose a Project:
Select aqExample

![AMET Website Select Database and Project](./AMET_website_choose_database_and_project.png)

Under AQ Observation Networks
Select  AQS - Hourly (e.g. NO,NO2,NOx,NOy,SO2,CO,PM2.5,O3,etc.)

Under Species to Plot
Select PM25_TOT

![AMET Website Select Obs Network and Species](./AMET_website_select_AQ_Observ_Networks_and_Species_to_Plot.png)

Under Choose Program to Run
Select Spatial Plot > Spatial Plot(multi networks)

Select Run Program

![AMET Website Select Plot and Run Program](./amet_website_run_programs.png)

Results of options selected in querygen_aq.php

![AMET Website Result](./amet_results_from_query_top.png)

PM2.5_TOT Normalized Mean Bias Plot

![AMET Normalized Mean Bias Spatial Plot](./amet_nmb.png)

PM2.5_TOT Normalized Mean Error Plot

![AMET Normalized Mean Error Spatial Plot](./amet_nme.png)

PM2.5_TOT Mean Bias Plot

![AMET Mean Bias Spatial Plot](./amet_mb.png)

# Create O3_8hrmax Density Scatterplot

Under AQ Observation Networks
Select AQS - Daily O3 (1-hr and 8-hr max) O3

Under Species to Plot
Select O3_8hrmax

![AMET Website Select Obs Network and Species](./amet_select_aq_obs_network_AQS_Daily_O3_species_to_plot_O3_8hrmax.png)

Under Choose Program to Run
Select Density Scatterplot (single run, single network) 

![AMET Website Select Plot and Run Program](./amet_website_run_programs.png)

Results of options selected in querygen_aq.php form

![AMET Website Result](./amet_result_query_O3_8hrmax_scatterplot.png)

Scatterplot of O3_8hrmax

![Scatterplot of O3_8hrmax](./amet_plot_density_scatterplot_singlerun_singlenetwork.png)


# Create Soccerplot using Improve, CSN, Castnet Observational Networks for species SO4, NO3, NH4

Under Species to Plot
Select SO4, NO3, and NH4

![AMET Website Select Obs Network and Species](./amet_select_aq_obs_network_Improve_CSN_CASTNET_SPECIES_SO4_NO3_NH4.png)

Under Choose Program to Run
Select Density Scatterplot (single run, single network)

![Choose Program to Run](./amet_select_run_soccerplot.png)

Results of querygen_aq.php (links)

![AMET Website Result](amet_result_query_soccerplot_links.png)

Soccerplot Generated

![Soccerplot](./amet_result_query_soccerplot.png)

# Create Stacked Bar Plot using CSN Network for PM2.5

Under Observation Network
Select CSN

Under Species to Plot
Select PM25_TOT

![AMET Website Select Obs Network and Species](./amet_select_CSN_PM25_TOT.png)

Under Choose Program to Run
Select PM2.5 Stacked Bar Plot AE6 (CSN or IMPROVE, multirun)

![AMET Website Result of Query](./amet_result_query_stacked_barplot_ae6.png)

Stacked Bar Plot of PM2.5 using CSN Network

![Stacked Bar Plot](./amet_plot_PM25_Stacked_BarPlot_AE6.png)

# Create Hourly Boxplot using AQS Hourly and O3 Species

Under Observation Network
Select AQS Hourly

Under Species to Plot
Select O3

![AMET Website Select Obs Network and Species](./amet_select_AQS_hourly_and_O3_species.png)

Under Choose Program to Run
Select Hourly Boxplot (single network, multiple runs)

![Query Result](./amet_result_query_hourly_boxplot.png)

Hourly Boxplot of O3

![Hourly Boxplot of O3](./amet_plot_hourly_boxplot_O3.png)


# Create Interactive Hourly Timeseries of O3, NOY, and Isoprene using Plotly

Under Observation Network
Select AQS Hourly

Under Species to Plot
Select O3, Isoprene, NOY

![AMET select AQS Hourly and Multispecies](./amet_select_AQS_hourly_multiple_species_O3_NOY_isoprene.png)

Under Choose Program to Run
Choose Plotly Multi-species Timeseries

![AMET run Plotly Multispecies Timeseries](./amet_run_plotly_multispecies_timeseries.png)

Plotly Timeseries of O3, NOY, and Isoprene
Note, this plot is interactive, and you can turn off items by clicking on an item in the legend, and also window to a specific time within the plot.

![Hourly Timeseries Plot of O3](./amet_plotly_hourly_timeseries_multispecies.png)

# Create Bugle Plot of PM2.5_TOT for AQS Daily, CSN, and IMPROVE

Under Observation Network
Select AQS Daily, CSN, and IMPROVE

Under Species to Plot
Select PM25_TOT

![AMET select AQS Daily CSN and IMPROVE and PM25_TOT](./amet_select_AQS_daily_CSN_IMPROVE_PM25_TOT.png)

Under Choose Program to Run
Choose Bugle Plot(Multiple Networks) under Misc Scripts

![AMET run Bugle Plot](./amet_run_bugle_PM25_TOT.png)

Bugle Plot of Normalized Mean Bias (NMB) PM25_TOT for Networks AQS Hourly and AQS Daily

![Bugle Plot of NMB PM25_TOT](./amet_plot_bugle_PM25_TOT_Daily_CSN_IMPROVE_NMB.png)

Bugle Plot of Normalized Mean Error (NME) PM25_TOT for Networks AQS Hourly and AQS Daily

![Bugle Plot of NMB PM25_TOT](./amet_plot_bugle_PM25_TOT_AQS_Daily_CSN_IMPROVE_NME.png)


# Load your own AQ model data to MariaDB

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
total 724
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
-rwxrwxr-x 1 www-data www-data 259423 Sep 29 18:30 querygen_met.php
-rw-rw-r-- 1 www-data www-data   3861 Oct 10 17:10 amet-lib.php
-rwxrwxr-x 1 www-data www-data   2061 Oct 10 17:24 amet-config.R
-rw-rw-r-- 1 www-data www-data   2084 Oct 10 17:27 amet-www-config.php
-rw-rw-r-- 1 www-data www-data  11397 Oct 10 17:30 run_info.template
-rwxrwxr-x 1 ubuntu   ubuntu   362697 Oct 10 19:58 querygen_aq.php
drwxrwxrwx 2 www-data www-data  16384 Nov  3 15:12 cache
```

## Upload your data

Change to the directory on /shared volume

```
cd /shared/AMET_v16/model_data/AQ/ 
mkdir new_project
```

Use the s3 cp command to obtain your data

```
cd new_project
aws s3 --no-sign-request --region=us-east-1 cp --recursive s3://[your_project_bucket_name]
```

## Load your project data into the database

Create a new project under the script_db directory

```
cd ~/AMET_v16/scripts_db/
cp -rp aqExample new_project
cd new_project
mv aqProject_pre_and_post.csh new_project_pre_and_post.csh
```

Modify the project name in the script

```
vi new_project_pre_and_post.csh

Change:
  set APPL      = aqExample         #> Application Name (e.g. Gridname)
to:
  set APPL      = new_project         #> Application Name (e.g. Gridname)
```

Edit the run description

```
Change:
 setenv RUN_DESCRIPTION "CMAQv5.5 AMET aqExample test case. July 2018."
to
 setenv RUN_DESCRIPTION "CMAQv5.5 AMET new project. Nov. 2025"
```

Edit the path to the combine output, if that is what you are uploading for your new_project.


