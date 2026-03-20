# AMET on AWS

The Atmospheric Model Evaluation Tool (AMET) (Appel et al., 2011) matches the model output for particular locations to the corresponding observed values from one or more networks of monitors. These pairings of values (model and observation) are then used to statistically and graphically analyze the model’s performance. 

AMET Website helps users generate and view plots created by AMET R programs using a web browser. 

Select projects, species, observational networks and programs to run using the interactive website with check box, and pull-down menue options. Create plots by selecting one or more observation networks and species, and select the program to run. Click on the `Run Program` button to run the program for the selected observation network and species on the VM. The R program queries the database, creates the plots, and provides links for the user to view either a pdf or png or html (for interactive plots) version of each plot.  

Multiple programs are available to choose from for each plot type including Scatter Plots, Time Series Plots, Spatial Plots, Box Plots, Stacked Bar Plots, Kelly Plots, Soccer Plots. 

Programs that use Plotly are interactive, allowing you to subset the time range, and enable or disable items displayed on the plot by clicking on them in the legend.

Some programs also support model to model comparisons by selecting multiple projects, and also support display of results from multiple observation networks, and for multiple species on the same plot.

<a href="https://github.com/USEPA/AMET/blob/1.5/docs/AMET_User_Guide_v15.md#Overview">Link to AMET User Guide</a>

## Learn how to use AMET on AWS

- Create a VM with preloaded AMET databases and projects
- Perform analysis of the 3 MET projects (mcip, wrf, mpas)  provided using the AMET Met Website
- Perform analysis using the AQ project aqExample and 18 EQUATES projects using the AMET AQ Website
- Load model data and observation data for a new project
- Troubleshoot and avoid errors

## Databases and Projects Available

<b>Database: amet</b>

<details>
  <summary> Projects | Click to expand!</summary>
<ol><b>AIR QUALITY</b>
<li>aqExample CMAQv5.5 test case July 2018</li>
</ol>
<ol><b>METEOROLOGY</b>
<li>metExample_mcip, MCIP Test Case July 2016</li>
<li>metExample_wrf, WRF Test Case July 2016</li>
<li>metExample_mpas, MPAS Test Case July 2016</li>
</ol>
</details>


<b>Database: amad_EQUATES</b>

<details>
<summary> Projects | Click to expand!</summary>
<ol><b>Air Quality</b>
<li>CMAQv532_12US1_2002</li>
<li> CMAQv532_12US1_2003</li>
<li> CMAQv532_12US1_2004</li>
<li> CMAQv532_12US1_2005</li>
<li> CMAQv532_12US1_2006</li>
<li> CMAQv532_12US1_2007</li>
<li> CMAQv532_12US1_2008</li>
<li> CMAQv532_12US1_2009</li>
<li> CMAQv532_12US1_2010</li>
<li> CMAQv532_12US1_2011</li>
<li> CMAQv532_12US1_2012</li>
<li> CMAQv532_12US1_2013</li>
<li> CMAQv532_12US1_2014</li>
<li> CMAQv532_12US1_2015</li>
<li> CMAQv532_12US1_2016</li>
<li> CMAQv532_12US1_2017</li>
<li> CMAQv532_12US1_2018</li>
<li> CMAQv532_12US1_2019</li>
</ol>
</details>

# Spin up a server using pre-installed AMET AMI

<br>Note, the AMI is currently private, and only available upon request. Please send an email if you would like to be a beta-tester.</br>
<a href="mailto:lizadams@email.unc.edu">Send Email</a>

 * Select AMI named AMETv1.6_web  that contains the AMETv1.6 installation with all data for MET and AQ loaded into database
 * Select Launch instance from AMI
 * Select Instance Type t3.xlarge (4vcpu and 16 GB memory) or t3.large (2 vcpu 8 GB memory)
 * Select key pair
 * Select existing security group - AMET_mysql
 * AMET_mysql security group contains permissions for port 443 and 3306 for inbound and outbound open to all or restricted to your IP address or you can add these permissions when you launch a new instance from the AMI.

![AMET Security Group](./amet_mysql_security_group_inbound_and_outbound_rules.png)

## EC2 Instance Type Cost
T3 instance type, physical processor: Intel Skylake E5, CPU Architecture:  x86_64 

| EC2 Instance Type      | # vCPUs | Memory | Cost/hour | Cost/day | 
| ---------------------- | ------- | -----  | --------  | -----    | 
| t3.2xlarge             |   8     | 32GB   | $.33      | $7.92    |
| t3.xlarge              |   4     | 16GB   | $.166     | $3.98    |
| t3.large               |   2     | 4GB    | $.083     | $1.99    |

## Storage type costs

A 500 GiB AWS gp3 EBS volume typically costs $40.00 per month for storage alone ($0.08 per GiB-month)
3,000 IOPS & 125 MB/s throughput free

The Amazon Machine Image (AMI) with 500 GB of storage, which relies on EBS snapshots, typically costs
$25.00 per month ($0.05 per GB-month) in the US East region


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
#If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

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

Use the website to select the database, project, observation network, variables to plot, and plotting programs.<br>

Note, errors may occur when you make selections on the AMET Website, see a list of typical error types below.<br>

Click on the arrow to display the list the available programs for creating different types of plots.<br>

# Programs to create plots (74)
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

# Observation Networks (48) 
<details>
  <summary>AQ Observation Networksi (35) | Click to expand!</summary>
<ol>Name of US Air Quality Monitoring Network
<li>IMPROVE (e.g. SO4,NO3,PM2.5,EC,OC,TC)</li>
<li>CSN (e.g. SO4,NO3,NH4,PM2.5,EC,OC,TC)</li>
<li>CASTNet (e.g. SO4,NO3,NH4,SO2,HNO3,TNO3)</li>
<li>CASTNet - Hourly (O3, RH, Precip, T, Solor Rad, WSPD, WDIR)</li>
<li>CASTNet Daily (1-hr and 8-hr max O3)</li>
<li>CASTNet Dry Dep (SO4,NO3,NH4,HNO3,TNO3,O3,SO2)</li>
<li>CAPMoN (SO4,NO3,NH4,HNO3,TNO3,SO2)</li>
<li>NAPS - Hourly (O3,NO,NO2,NOX,SO2,PM2.5,PM10)</li>
<li>NAPS - Daily O3 (1-hr and 8-hr max O3)</li>
<li>NADP (e.g. SO4,NO3,NH4,Precip, Cl Ion)</li>
<li>AMON (NH3)</li>
<li>AIRMON (Deposition) (SO4,NO3,NH4,Precip)</li>
<li>AQS - Hourly (e.g. NO,NO2,NOx,NOy,SO2,CO,PM2.5,O3,etc.)</li>
<li>AQS - Daily O3 (1-hr and 8-hr max O3)</li>
<li>AQS - Daily (e.g. PM2.5,PM10, and PAMS species)</li>
<li>AQS - Daily VOCs (select PAMS species)</li>
<li>AQS - Daily OAQPS O3 (Various 8-hr max O3)</li>
<li>AQS - Daily (Old name) PM2.5,PM10, and PAMS species network</li>
<li>SEARCH Hourly (e.g. O3,CO,SO2,NO,HNO3,etc.)</li>
<li>SEARCH Daily (Fine and Coarse Mode Species)</li>
<li>AERONET (AOD: 340, 380, 440, 500, 675, 870, 1020, 1640)</li>
<li>FluxNet (Soil/Flux variables)</li>
<li>NOAA ESRL (Hourly O3)</li>
<li>TOAR (Daily O3 values)</li>
<li>TOAR2 Hourly (O3,CO,SO2,NO,NO2,NOX,PM2.5)</li>
<li>TOAR2 Daily O3 (e.g., 1-hr max, MDA8)</li>
<li>TOAR2 Daily Average (O3,CO,SO2,NO,NO2,NOX,PM2.5)</li>
<li>PurpleAir Hourly (PM2.5)</li>
<li>PurpleAir Daily (Daily PM2.5)</li>
<li>AirNow Hourly (O3, PM2.5)</li>
<li>AirNow Daily O3 (e.g., 1-hr max, MDA8 O3)</li>
<li>NYCCAS (Two-week PM2.5)</li>
<li>MDN (Hg)</li>
<li>AMTIC (HAPs)</li>
<li>Model_Model</li>
</ol>
</details>

<details>
  <summary> European Networks (10) | click to expand!</summary>
<ol>Name of European Network
<li>ADMN (SO4,NO3,NH4,Precip, Na Ion, Cl Ion)</li>
<li>AGANET (HCl, NO2, NOY, SOX, HNO3, SO2, Cl, Na)</li>
<li>AirBase_Hourly (NO, NO2, NOX, SO2, CO, PM2.5, PM10, O3)</li>
<li>AirBase_Daily (NO, NO2, NOX, SO2, CO, PM2.5, PM10, O3)</li>
<li>AURN_Hourly (NO, NO2, NOX, SO2, CO, PM2.5, PM10, O3)</li>
<li>AURN_Daily (NO, NO2, NOX, SO2, CO, PM2.5, PM10, O3)</li>
<li>EMEP - Hourly (NO, NO2, NOX, SO2, CO, PM2.5, PM10, O3)</li>
<li>EMEP - Daily (SO4, NO3, NH44, trace metals, PM2.5, PM10, O3)</li>
<li>EMEP - Daily O3 (1-rh and 8-hr max O3)</li>
<li>EMEP - Dep (SO4, NO3, NH44, Cl, Na, trace metals)</li>
</ol>
</details>

<details>
   <summary>Campaigns (3) | Click to expand!</summary>
<ol>Name of Campaign
<li>CALNEX</li>
<li>SOAS</li>
<li>Special </li>
</ol>
</details>

# Air Quality and Met Species (172)
<details>
  <summary>List of AQ Species available for EQUATES (40) | Click to expand!</summary>
<ol>Species available for EQUATES
<li>SO4 </li>
<li>NO3</li>
<li>NH4</li>
<li>EC</li>
<li>OC</li>
<li>TC </li>
<li>other, PMOther</li>
<li>ncom</li>
<li>Cl, Cl Ion</li>
<li>Na, Na Ion</li>
<li>PM_TOT, PM2.5 Mass(I+J)	</li>
<li>PM_FRM, PM2.5 FRM Equiv.(I+J)</li>	
<li>PM25_SO4, PM2.5 SO4	</li>
<li>PM25_NO3, PM_2.5 NO3	</li>
<li>PM25_NH4, PM_2.5 NH4	</li>
<li>PM25_TOT, PM_2.5 Total Mass	</li>
<li>PM25_FRM, PM_2.5 FRM Equiv.	</li>
<li>PM25_EC, PM_2.5 EC	</li>
<li>PM25_OC, PM_2.5 OC	</li>
<li>PM25_TC, PM_2.5 TC	</li>
<li>PM25_Cl, PM_2.5 Cl Ion	</li>
<li>PM25_Na, PM_2.5 Na Ion	</li>
<li>PMC_SO4, PM_Coarse SO4	</li>
<li>PMC_NO3, PM_Coarse NO3	</li>
<li>PMC_NH4, PM_Coarse NH4	</li>
<li>PMC_TOT, PM_Coarse Total Mass</li>	
<li>PMC_Cl, PM_Coarse Cl Ion	</li>
<li>PMC_Na, PM_Coarse Na Ion	</li>
<li>PM10, PM10 Mass	</li>
<li>Na, Sodium(Na)	</li>
<li>Cl, Chlorine(Cl)	</li>
<li>Fe, Iron(Fe)	</li>
<li>Al, Aluminium(Al)	</li>
<li>Si, Silicon(Si)	</li>
<li>Ti, Titanium(Ti)	</li>
<li>Ca, Calcium(Ca)	</li>
<li>Mg, Magnesium(Mg)	</li>
<li>K, Potassium(K)	</li>
<li>Mn, Mangenese(Mn)	</li>
<li>soil, Soil(IMPROVE Eqn.)	</li>
</ol>
</details>
<details>
 <summary>Subset of variables available for aqExample (126) | Click to expand!</summary>
Note, not all species are available at all observation networks.
Example: PAMS Network has select VOCs, NO and NO2. 
a href="https://rstudio-connect.sonomatechdata.com/pams_dashboard/">Species available for PAMS Observation Network</a>
<ol>Subset of Gas phase variables (24)
<li>O3, Ozone (hourly or daily)</li>
<li>O3_1hrmax, Ozone 1-hrmax(daily)</li>
<li>O3_8hrmax, Ozone 8-hrmax(daily)	</li>
<li>O3_1hrmax_9cell, Ozone 1-hrmax 9-cell avg(daily)</li>
<li>O3_8hrmax_9cell, Ozone 8-hrmax 9-cell avg(daily)</li>
<li>O3_1hrmax_time, Ozone 1-hrmax hour(daily)</li>
<li>SO2</li>
<li>NH3</li>
<li>HNO3</li>   
<li>TNO3, TNO3(NO3+HNO3)</li>
<li>CO</li>
<li>NO</li>
<li>NO2</li>
<li>NOX</li>
<li>NOY</li>
<li>H2O2</li>
<li>HOx</li>
<li>Acetaldehyde</li>
<li>Formaldehyde</li>
<li>Benzene</li>
<li>Ethane</li>
<li>Ethylene</li>
<li>Isoprene</li>
<li>Toluene</li>
</ol>
<ol>Subset of Particles(40)
<li>SO4</li>
<li>NO3</li>
<li>NH4</li>
<li>EC</li>
<li>OC</li>
<li>TC</li>
<li>other, PMOther	</li>
<li>ncom</li>
<li>Cl, Cl Ion	</li>
<li>Na, Na Ion	</li>
<li>PM_TOT, PM2.5 Mass(I+J)	</li>
<li>PM_FRM, PM2.5 FRM Equiv.(I+J)	</li>
<li>PM25_SO4, PM2.5 SO4	</li>
<li>PM25_NO3, PM_2.5 NO3	</li>
<li>PM25_NH4, PM_2.5 NH4	</li>
<li>PM25_TOT, PM_2.5 Total Mass	</li>
<li>PM25_FRM, PM_2.5 FRM Equiv.	</li>
<li>PM25_EC, PM_2.5 EC	</li>
<li>PM25_OC, PM_2.5 OC	</li>
<li>PM25_TC, PM_2.5 TC	</li>
<li>PM25_Cl, PM_2.5 Cl Ion	</li>
<li>PM25_Na, PM_2.5 Na Ion	</li>
<li>PMC_SO4, PM_Coarse SO4	</li>
<li>PMC_NO3, PM_Coarse NO3	</li>
<li>PMC_NH4, PM_Coarse NH4	</li>
<li>PMC_TOT, PM_Coarse Total Mass</li>	
<li>PMC_Cl, PM_Coarse Cl Ion	</li>
<li>PMC_Na, PM_Coarse Na Ion	</li>
<li>PM10, PM10 Mass	</li>
<li>Na, Sodium(Na)	</li>
<li>Cl, Chlorine(Cl)	</li>
<li>Fe, Iron(Fe)	</li>
<li>Al, Aluminium(Al)	</li>
<li>Si, Silicon(Si)	</li>
<li>Ti, Titanium(Ti)	</li>
<li>Ca, Calcium(Ca)	</li>
<li>Mg, Magnesium(Mg)	</li>
<li>K, Potassium(K)</li>
<li>Mn, Mangenese(Mn)	</li>
<li>soil, Soil(IMPROVE Eqn.)	</li>
</ol>
<ol>Subset of Wet/Dry Deposition Species (25)
<li>SO4_dep, SO4(wetdep) </li>
<li>SO4_conc, SO4(wetconc)		 </li>
<li>NO3_dep, NO3(wetdep)		 </li>
<li>NO3_conc, NO3(wetconc)		 </li>
<li>NH4_dep, NH4(wetdep)		 </li>
<li>NH4_conc, NH4(wetconc)		 </li>
<li>Cl_dep, Cl Ion(wetdep)		 </li>
<li>Cl_conc, Cl Ion(wetconc)		 </li>
<li>CA_dep, Ca(wetdep)		 </li>
<li>CA_conc, Ca(wetconc)		 </li>
<li>MG_dep, Mg(wetdep)		 </li>
<li>MG_conc, Mg(wetconc)		 </li>
<li>K_dep, K(wetdep)		 </li>
<li>K_conc, K(wetconc)		 </li>
<li>NA_dep, Na(wetdep)		 </li>
<li>NA_conc, Na(wetconc)		 </li>
<li>HGconc, Hg(wetconc)		 </li>
<li>HGdep, Hg(wetdep)		 </li>
<li>SO4_ddep, SO4(drydep)		 </li>
<li>NO3_ddep, NO3(drydep)		 </li>
<li>NH4_ddep, NH4(drydep)		 </li>
<li>HNO3_ddep, HNO3(drydep)		 </li>
<li>TNO3_ddep, TNO3(drydep)		 </li>
<li>O3_ddep, O3(drydep)		 </li>
<li>SO2_ddep, SO2(drydep)		 </li>
</ol>
<ol>Subset of Toxics (37)
<li>Acrolein</li>
<li>Acrylonitrile</li>
<li>Acetaldehyde</li>
<li>Benzene</li>    
<li>BR2_C2_12</li> 
<li>Butadiene, 13Butadiene13</li>	
<li>Cadmium_PM10</li>
<li>Cadmium_PM25</li>
<li>Carbontet  </li>
<li>Chromium_PM10</li>
<li>Chromium_PM2</li>
<li>CHCL3      </li>
<li>CL_ETHE   </li>
<li>CL2      </li>
<li>CL2_C2_12</li>
<li>CL2_ME  </li>
<li>CL3_ETHE</li>
<li>CL4_ETHE</li>
<li>CL4_Ethane1122 </li>
<li>CR_III_PM10   </li>
<li>CR_III_PM25  </li>
<li>CR_VI_PM10  </li>
<li>CR_VI_PM25 </li>
<li>Dichlorobenzene</li>
<li>Formaldehyde  </li>
<li>Lead_PM10    </li>
<li>Lead_PM25   </li>
<li>Manganese_PM10  </li>
<li>Manganese_PM25 </li>
<li>MEOH</li>
<li>MXYL</li>
<li>Nickel_PM10 </li>
<li>Nickel_PM25 </li>
<li>OXYL     </li> 
<li>Propdichloride </li>
<li>PXYL </li>
<li>Toluene</li>
</ol>
</details>

<details>
<summary>Metorological Species for metExample (6) | Click to Expand!</summary>
<ol>Metorological Species (6)
<li>T(2m), 2 meter Temperature</li>
<li>Hourly Precipitation</li>
<li>Water Vapor Mixing Ratio</li>
<li>Wind Speed</li>
<li>Solar Radiation</li>
<li>Surface Pressure</li>
</ol>
</details>

</details>


# Example plots using the aqExample database

## Create PM2.5 Spatial Plots

<ul>
<li>Choose database</li>
  <ul>
    <li>select amet</li>
  </ul>
<li>Choose project 1
  <ul>
    <li>select aqExample</li>
  </ul>
</li>
</ul>

![AMET Website Select Database and Project](./AMET_website_choose_database_and_project.png)

<ul>
<li>Under AQ Observation Networks
<ul>
<li>Select  AQS - Hourly (e.g. NO,NO2,NOx,NOy,SO2,CO,PM2.5,O3,etc.)</li>
</ul>
</li>
</ul>


<ul>
<li>Under Species to Plot
<ul>
<li>Select PM25_TOT</li>
</ul>
</li>
</ul>

![AMET Website Select Obs Network and Species](./AMET_website_select_AQ_Observ_Networks_and_Species_to_Plot.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Select Species Statistics and Spatial Plot(multi networks)</li>
</ul>
</li>
</ul>

<li>Select Run Program</li>

![AMET Website Select Plot and Run Program](./amet_website_run_programs.png)

<li>Results of options selected in querygen_aq.php</li>

![AMET Website Result](./amet_results_from_query_top.png)

<li>PM2.5_TOT Normalized Mean Bias Plot</li>

![AMET Normalized Mean Bias Spatial Plot](./amet_nmb.png)

<li>PM2.5_TOT Normalized Mean Error Plot</li>

![AMET Normalized Mean Error Spatial Plot](./amet_nme.png)

<li>PM2.5_TOT Mean Bias Plot</li>

![AMET Mean Bias Spatial Plot](./amet_mb.png)

</ul>

## Create O3_8hrmax Density Scatterplot

<ul>
<li>Under AQ Observation Networks</li>
<ul>
<li>Select AQS - Daily O3 (1-hr and 8-hr max) O3</li>
</ul>
</ul>

<ul>
<li>Under Species to Plot</li>
<ul>
<li>Select O3_8hrmax</li>
</ul>
</ul>

![AMET Website Select Obs Network and Species](./amet_select_aq_obs_network_AQS_Daily_O3_species_to_plot_O3_8hrmax.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Select Density Scatterplot (single run, single network) </li>
</ul>
</li>
</ul>

![AMET Website Select Plot and Run Program](./amet_website_density_scatterplot.png)

<li>Results of options selected in querygen_aq.php form</li>

![AMET Website Result](./amet_result_query_O3_8hrmax_scatterplot.png)

<li>Scatterplot of O3_8hrmax</li>

![Scatterplot of O3_8hrmax](./amet_plot_density_scatterplot_singlerun_singlenetwork.png)


## Create Soccerplot using Multiple Obs Networks, Multiple Species

<ul>
<li>Under AQ Observation Networks
<ul>
<li>Select IMPROVE</li>
<li>Select CSN</li>
<li>Select Castnet</li>
</ul>
</li>
</ul>


<ul>
<li>Under Species to Plot
<ul>
<li>Select SO4</li>
<li>Select NO3</li>
<li> Select NH4</li>
</ul>
</li>
</ul>

![AMET Website Select Obs Network and Species](./amet_select_aq_obs_network_Improve_CSN_CASTNET_SPECIES_SO4_NO3_NH4.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Select Soccergoal Plot (multiple networks)</li>
</ul>
</li>
</ul>

![Choose Program to Run](./amet_select_run_soccerplot.png)

<li>Results of querygen_aq.php (links)</li>

![AMET Website Result](amet_result_query_soccerplot_links.png)

<li>Soccerplot Generated</li>

![Soccerplot](./amet_result_query_soccerplot.png)

## Create Stacked Bar Plot using CSN Network for PM2.5

<ul>
<li>Under Observation Network
<ul>
<li>Select CSN</li>
</ul>
</li>
</ul>

<ul>
<li>Under Species to Plot
<ul>
<li>Select PM25_TOT</li>
</ul>
</li>
</ul>


![AMET Website Select Obs Network and Species](./amet_select_CSN_PM25_TOT.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Select PM2.5 Stacked Bar Plot AE6 (CSN or IMPROVE, multirun)</li>
</ul>
</li>
</ul>

<li>Results of querygen_aq.php (links)</li>

![AMET Website Result of Query](./amet_result_query_stacked_barplot_ae6.png)

<li>Stacked Bar Plot of PM2.5 using CSN Network</li>

![Stacked Bar Plot](./amet_plot_PM25_Stacked_BarPlot_AE6.png)

## Create Hourly Boxplot using AQS Hourly and O3 Species

<ul>
<li>Under Observation Network
<ul>
<li>Select AQS Hourly</li>
</ul>
</li>
</ul>

<ul>
<li>Under Species to Plot
<ul>
<li>Select O3</li>
</ul>
</li>
</ul>

![AMET Website Select Obs Network and Species](./amet_select_AQS_hourly_and_O3_species.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Select Hourly Boxplot (single network, multiple runs)</li>
</ul>
</li>
</ul>

![Query Result](./amet_result_query_hourly_boxplot.png)

<li>Hourly Boxplot of O3</li>

![Hourly Boxplot of O3](./amet_plot_hourly_boxplot_O3.png)

## Create Daily Boxplot using AQS Daily and O3_8hrmax Species

<ul>
<li>Under Observation Network 
<ul>
<li>AQS - Daily O3 (1-hr and 8-hr max O3)</li>
</ul>
</li>
</ul>

<ul>
<li>Under Species to Plot
<ul>
<li>Select O3_8hrmax</li>
</ul>
</li>
</ul>
    
![AMET Website Select Obs Network and Species](./amet_select_AQS_Daily_and_O3_8hrmax_species.png)
    
<ul>
<li>Under Choose Program to Run
<ul>
<li>Select Plotly Boxplot (single network, multiple runs)</li>
</ul>
</li>
</ul>

![Select Program](./amet_result_program_interactive_boxplot.png)

Query result
![Query Result](./amet_result_query_daily_interactive_boxplot.png)

<li>Daily Boxplot of O3_8hrmax</li>

![Daily Boxplot of O3_8hrmax](./amet_plot_daily_interactive_boxplot_O38hrmax.png)


## Create Day of Week (DoW)  Boxplot using AQS Daily and O3_8hrmax Species
    
<ul>
<li>Under Observation Network
<ul>
<li>Select AQS Daily O3 (1-hr and 8-hr max O3)</li>
</ul>
</li>
</ul>

<ul>
<li>Under Species to Plot
<ul>
<li>Select O3_8hrmax</li>
</ul>
</li>
</ul>
    
![AMET Website Select Obs Network and Species](./amet_select_AQS_Daily_O3_8hrmax_species.png)
    
<ul>
<li>Under Choose Program to Run
<ul>
<li>Select  Day of Week Boxplot (single network, multiple runs)</li>
</ul>
</li>
</ul>

![Query Result](./amet_result_query_dow_boxplot.png)

<li>Day of Week (DoW) Boxplot of O3</li>

![DoW Boxplot of O3_8hrmax](./amet_plot_dow_boxplot_O3_8hrmax.png)



## Create Interactive Hourly Timeseries using Plotly

<ul>
<li>Under Observation Network
<ul>
<li>Select AQS Hourly</li>
</ul>
</li>
</ul>

<ul>
<li>Under Species to Plot
<ul>
<li>Select O3</li>
<li>Select Isoprene</li>
<li> Select NOY</li>
</ul>
</li>
</ul>

![AMET select AQS Hourly and Multispecies](./amet_select_AQS_hourly_multiple_species_O3_NOY_isoprene.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Choose Plotly Multi-species Timeseries</li>
</ul>
</li>
</ul>

![AMET run Plotly Multispecies Timeseries](./amet_run_plotly_multispecies_timeseries.png)

Plotly Timeseries of O3, NOY, and Isoprene<br>
Note, this plot is interactive, and you can turn off items by clicking on an item in the legend, and also window to a specific time within the plot.<br>

![Interactive Hourly Timeseries Plot of O3, Isoprene, NOY](./amet_plotly_hourly_timeseries_multispecies.png)

## Create Bugle Plot of PM2.5_TOT for AQS Daily, CSN, and IMPROVE

<ul>
<li>Under Observation Network
<ul>
<li> Select AQS Daily</li>
<li> Select CSN</li>
<li> Select IMPROVE</li>
</ul>
</li>
</ul>

<ul>
<li> Under Species to Plot
<ul>
<li>`Select PM25_TOT`</li>
</ul>
</li>
</ul>

![AMET select AQS Daily CSN and IMPROVE and PM25_TOT](./amet_select_AQS_daily_CSN_IMPROVE_PM25_TOT.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Choose Bugle Plot(Multiple Networks) under Misc Scripts</li>
</ul>
</li>
</ul>

![AMET run Bugle Plot](./amet_run_bugle_PM25_TOT.png)

<li>Bugle Plot of Normalized Mean Bias (NMB) PM25_TOT for Networks AQS Hourly and AQS Daily</li>

![Bugle Plot of NMB PM25_TOT](./amet_plot_bugle_PM25_TOT_Daily_CSN_IMPROVE_NMB.png)

<li>Bugle Plot of Normalized Mean Error (NME) PM25_TOT for Networks AQS Hourly and AQS Daily</li>

![Bugle Plot of NME PM25_TOT](./amet_plot_bugle_PM25_TOT_AQS_Daily_CSN_IMPROVE_NME.png)


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

Check if observation data is available.

```
cd ~/AMET_v16/obs
ls -lrt */*
```

Currently only the obsdata for 2018 has been copied from the s3 bucket to this location.
Follow instructions on the readme file to copy additional years, and then extract them.

Once your model data and the observation data is available, run the net_project_pre_and_post.csh script.

# Loading EPA's EQUATES Database

This method was used to load the EQUATES Database to the EC2 instance.

Create the amad_EQUATES database using mysql

```
mysql CREATE DATABASE amad_EQUATES;
```

Imported the mysql dump provided by Wyat Appel using the following command.

```
sudo mysql -p amad_EQUATES < amad_EQUATES.dump & 
```

After the successful import, was able to use the AMET Website to view all of the imported tables.

![AMET AQ WEBSITE display of 2002-2019](./amad_EQUATES_tables.png)

# Example plots using the EQUATES 2002-2019 Projects in the amad_EQUATES database

## Create Interactive Year-long Monthly Statistics Plot (single network)

<ul>
<li>Select Database ID
<ul>
<li>Select amad_EQUATES
</ul>
</li>
</ul>

<ul>
<li>Select Project ID
<ul>
<li>Select CMAQv532_12US1_2019
</ul>
</li>
</ul>


<ul>
<li>Under Observation Network
<ul>
<li> Select AQS Hourly</li>
</ul>
</li>
</ul>

<ul>
<li> Under Species to Plot
<ul>
<li>Select O3</ul>
</ul>
</li>
</ul>

![AMET select AQS Hourly and O3](./amet_select_AQS_hourly_O3.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Interactive Year-long Monthly Statistics Plot (single network)</li>
</ul>
</li>
</ul> 

![AMET run Interactive Year-long Monthly Statistics Plot](./amet_run_year_long_statistics.png )

<li>Interactive Year-long Monthly Statistics Plot using Networks AQS Hourly and Ozone</li>

![Year-long Monthly Statistics Plot of O3](./CMAQv532_12US1_2019_O3_stats_plot.png)

## Create Interactive Plotly Mutli-simulation Timeseries  (single network)

<ul>
<li>Select Database ID
<ul>
<li>Select amad_EQUATES
</ul>
</li>
</ul>

<ul>
<li>Select Project ID
<ul>
<li>Select CMAQv532_12US1_2018
<li>Select CMAQv532_12US1_2017
</ul>
</li>
</ul>


<ul>
<li>Under Observation Network
<ul>
<li> Select AQS Daily (e.g. PM2.5, PM10, and PAMS species)</li>
</ul>
</li>
</ul>

<ul>
<li> Under Species to Plot
<ul>
<li>Select PM25_TOT</ul>
</ul>
</li>
</ul>

![AMET select AQS Daily and PM25_TOT](./amet_select_AQS_Daily_PM25_TOT.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Plotly Multi-simulation Timeseries</li>
</ul>
</li>
</ul>

![AMET run Plotly Multi-simulation Timeseries Plot](./amet_multisimulation_timeseries.png )

## Create Interactive Plotly Mutli-simulation Timeseries for SO2 and AQS Hourly (single network)

<ul>
<li>Select Database ID
<ul>
<li>Select amad_EQUATES
</ul>
</li>
</ul>

<ul>
<li>Select Project ID
<ul>
<li>Select CMAQv532_12US1_2018
<li>Select CMAQv532_12US1_2017
</ul>
</li>
</ul>


![AMET select multiple projects for multisimulation plots](./amet_select_multiple_projects.png)

<ul>
<li>Under Observation Network
<ul>
<li> AQS - Hourly (e.g. NO,NO2,NOx,NOy,SO2,CO,PM2.5,O3,etc.)
</ul>
</li>
</ul>

<ul>
<li> Under Species to Plot
<ul>
<li>Select SO2</ul>
</ul>
</li>
</ul>

![AMET select AQS Hourly and SO2](./amet_select_AQS_Hourly_SO2.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Plotly Multi-simulation Timeseries</li>
</ul>
</li>
</ul>

![AMET run Plotly Multi-simulation Timeseries Plot](./amet_plotly_multisimulation_timeseries.png )


<li>Interactive Plotly Multi-simulation (EQUATES 2017, 2018) Timeseries Plot using Networks AQS Hourly and SO2</li>

![Interactive Plotly Multi-simulation Timeseries Plot AQS Hourly, SO2](./CMAQv532_12US1_2018_2017_SO2_timeseries.png)


## Create Plotly Kelly Plot (single species, single network, full year data)

<ul>
<li>Select Database ID
<ul>
<li>Select amad_EQUATES
</ul>
</li>
</ul>

<ul>
<li>Select Project ID
<ul> 
<li>Select CMAQv532_12US1_2003
</ul>
</li>
</ul>


<ul>
<li>Under Observation Network
<ul>
<li> Select AQS Daily (e.g. PM2.5,PM10, and PAMS species) </li>
</ul>
</li>
</ul>

<ul>
<li> Under Species to Plot
<ul>
<li>Select PM2.5_TOT</ul>
</ul>
</li>
</ul>

![AMET select AQS Daily and PM2.5_TOT](./amet_select_AQS_daily_PM2.5_TOT.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Plotly Kelly Plot (single species, single network, full year data)</li>
</ul>
</li>
</ul>


![AMET run Plotly Kelly Plot](./amet_run_year_plotly_kelly_plot.png)

<li>Plotly Kelly Plot of AQS Daily and PM2.5_TOT</li>

![Plotly Kelly Plot of AQS Daily and PM2.5_TOT](./CMAQv532_12US1_2003_PM25_TOT_Kellyplot_NMB.png)

# Create Met Plots using the AMET Met Website 

Change the IP address to the public IP address for your instance in this example.

```
http://[your-ec2-external-ip-address]:443/querygen_met.php
```

Use the website to select the database, project, variables to plot, and plotting programs.
Click on the arrow to display the list the available programs for creating different types of plots.


## Programs to create plots

Uses can select one of 62 different programs in the AMET MET Website to create plots.
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
  <summary>Experimental Scripts (3) | Click to expand!</summary>
<ol>Name of R Script | Program (may not work correctly) 
    <li>AQ_Overlay_File.R | Create PAVE/VERDI Obs Overlay File (hourly/daily data only)</li>
    <li>AQ_Scatterplot_log.R | Log-Log Model/Ob Scatterplot (multiple networks)</li>
    <li>AQ_Spectral_Analysis.R | Spectral Analysis (single network, single run, experimental)</li>
</ol>
</details>

<b>Met Observation Networks</b>

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

## Create 2m Temperature Spatial Plots
<ul>
<li>Choose database
  <ul>
    <li>select amet</li>
  </ul>
</li>
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
<li>Choose Met Species 
  <ul>
    <li>select T(2m)</li>
  </ul>
</li>
</ul>


![AMET Meteorology Website Select Met Variable to use](./AMET_website_met_choose_variable_T.png)

<ul>
<li>Choose Program to Run
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

<ul>
<li>Under Met Variable to choose
<ul>
<li>Select T(2m)</li>
</ul>
</li>
</ul>

<ul>
<li>Under Choose Program to Run
<ul>
<li>Select Interactive Spatial Plot (multiple plots)</li>
</ul>
</li>
</ul>

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

<ul>
<li>Under Met Variable to choose
<ul>
<li>Select T(2m)</li>
</ul>
</li>
</ul>

<ul>
<li>Under Choose Program to Run
<ul>
<li>Select Density Scatterplot (single run, single network) </li>
</ul>
</li>
</ul>

![AMET Website Select Plot and Run Program](./met_plots/AMET_website_choose_density_scatterplot.png)

Results of options selected in querygen_met.php form

![AMET Website Result](./met_plots/AMET_website_result_query_T_2m_scatterplot.png)

Scatterplot of 2m Temperature

![Scatterplot of 2m Temperature](./met_plots/metExample_wrf_T_scatterplot_density.png)

## Create Timeseries Plot (single network, multiple sites averaged) for 2m Temperature

<ul>
<li>Under Met Variable to choose
<ul>
<li>Select T(2m)</li>
</ul>
</li>
</ul>

<ul>
<li>Under Choose Program to Run
<ul>
<li>Timeseries Plot (single network, multiple sites averaged)</li>
</ul>
</li>
</ul>

![AMET Website Select Plot and Run Program](./met_plots/amet_run_program_timeseries.png)

Results of options selected in querygen_met.php form

![AMET Website Result](./met_plots/AMET_website_result_query_T_2m_timeseries.png)

Timeseries Plot of 2m Temperature

![Timeseries plot of 2m Temperature](./met_plots/metExample_wrf_T_timeseries.png)


## Create Boxplot using METAR Met Observations and T(2m) Model Values

<ul>
<li>Under Met Observation Networks
<ul>
<li>Choose METAR</li>
</ul>
</li>
</ul>

<ul>
<li> Under Met Variable to Use
<ul>
<li>Select T(2m)</li>
</ul>
</li>
</ul>

![AMET Website Select Obs Network and Species](./met_plots/amet_select_METAR_and_T2.png)

<ul>
<li>Under Choose Program to Run
<ul>
<li>Boxplot (single network, multi-run)</li>
</ul>
</li>
</ul>

![Query Result](./amet_result_query_boxplot.png)

Boxplot of T2 all

![Boxplot of T2 all](./met_plots/metExample_wrf_T_boxplot_all.png)

Boxplot of T2 Bias

![Boxplot of T2 Bias](./met_plots/metExample_wrf_T_boxplot_bias.png)

Boxplot of T2 Normalized Bias

![Boxplot of T2 Normalized Bias](./met_plots/metExample_wrf_T_boxplot_norm_bias.png)

## Create Plotly Boxplot using METAR Met Observations and T(2m) Model Values

Under Met Observation Networks
Choose METAR

Under Met Variable to Use
Select T(2m) 

![AMET Website Select Obs Network and Species](./met_plots/amet_select_METAR_and_T2.png)

Under Choose Program to Run
Plotly Boxplot (single network, multi-run)

![Query Result](./met_plots/amet_result_query_boxplot_plotly.png)

Plotly Boxplot of T2

![Plotly Boxplot of T2 ](./met_plots/metExample_wrf_T_boxplot_plotly.png)

Note, the Bias and Normalized Bias Plots were not created successfully.

## Create Interactive Hourly Timeseries of T2 using Plotly

Under Met Observation Network
Select METAR

Under Met Species to Plot
Select T 

Under Choose Program to Run
Choose Plotly Multi-species Timeseries

![AMET run Plotly Multispecies Timeseries](./met_plots/amet_run_plotly_timeseries_multisimulation.png)

Note, this plot is interactive, and you can turn off items by clicking on an item in the legend, and also window to a specific time within the plot.

![Hourly Timeseries Plot of T](./met_plots/amet_plotly_hourly_timeseries_multispecies.png)

## Create Bugle Plot of T(2m)

<ul>
<li>Under Observation Network
<ul>
<li> Select METAR</li>
</ul>
</li>
</ul> 

<ul>
<li>Under Met Species to Plot
<ul>
<li> Select T(2m)</li>
</ul>
</li>
</ul> 

![AMET select METAR ](./met_plots/amet_select_METAR_T.png)

Under Choose Program to Run
Choose Bugle Plot(Multiple Networks) under Misc Scripts

![AMET run Bugle Plot](./met_plots/amet_run_bugle_T.png)

Bugle Plot of Normalized Mean Bias (NMB) T for METAR Obs Network

![Bugle Plot of NMB Temperature](./met_plots/metExample_wrf_T_bugle_plot_bias.png)

Bugle Plot of Normalized Mean Error (NME) Temperature for Networks METAR

![Bugle Plot of NMB Temp](./metExample_wrf_T_bugle_plot_error.png)


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

The wrfExample_mpas model data was 462 GB. The root volume of this AMI is only 500GB.
Therefore, you will need to attach another 1 TB ebs volume to the EC2 instance if you needed to load model data for a new MPAS project..
The model data for the projects that have already been loaded into the database have been deleted as they are no longer needed.

See these instructions to attach a new volume.
<a href="https://docs.aws.amazon.com/ebs/latest/userguide/ebs-attaching-volume.html">Instruction to attach EBS Volume to VM</a>
<a href="https://docs.aws.amazon.com/ebs/latest/userguide/ebs-using-volumes.html">Instruction to use EBS Volume on AWS</a>
To load this data into the database, you will also need to change the EC2 instance type from t3.large to t3.2xlarge.
<a href="https://repost.aws/questions/QUHXsEc4U1R_-ze2xuilqHwg/is-it-possible-to-change-instance-type-without-terminating-and-creating-new-instance-what-is-the-difference">Change instance type</a>

use the s3 cp command to upload your data to the /shared/AMET_v16/model_data/MET/new_project directory

## Load your project data into the database for a new MET project

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

## Load your project data into the database for a new AQ project

need to add this contents


# Types of Errors Creating Plots and how to avoid them.

## Selection of wrong inputs for the plot type selected to run 

- Selection of O3 for AQS Daily, when AQS Daily only supports O3_8hrmax and O3_1hrmax)
  - Pay attention to the description in paranthesis next to the Obs Network name: AQS - Daily O3 (1-hr and 8-hr max O3)
  - In order for a plot to be generated, the observational network and the project (model output) must both contain species selected by the user for the same time range of interest. 

- Date selection is automatically set for the first project, but if you add a second project, you need to change the data range to include that second project.
  - Pay attention to the dates selected!

- Selection of only one network for a plot program that is looking for multiple networks
  - Pay attention to the description in paranthesis next to the Program Name


## Error due to missing data

- MetExample_mcip_surface didn't load because the loop_over_days.csh script has that commented out, and the user needs to edit, link the required input files and rerun.
  - run a mysql query to verify that the data exists, or check your database loading logs

- Observation data not available to be loaded for specific networks, ie. METAR is the only network that appears to work for querygen_met.php 

- Plots failed using CSN and IMPROVE with PM25_TOT but worked for AQS-Daily for the plotly multisimulation timeseries plot using the EQUATES database.
  - The amad_EQUATES database contains a limited subset of observational networks (AQS Daily, AQS Hourly, CASNET, and NADP)

- Observational data must be download and extracted for all of the years that correspondfor each project (model data), to enable obs/model pairing and loading into the database.

## Bug or Error in the plot

- the legend symbols don't match the data, or data isn't plotted the way that the user expects.

- Bug - or error due to missing or mis-named program, search *.Rout for 'Fatal Error'

## Usability errors
  
- If programs are failing with a 'Killed' message, check to see if memory is being exceeded
  - login to the server and use htop to view the amount of memory/cpus being used

![AMET Memory Usage running Plotly Multisimulation Plot with EQUATES Data](./amet_htop_memory_usage_for_plotly_multisimulation.png)

  - consider upgrading the EC2 type to larger memory and cpus

- Error in loading the plot in the browser (browser slows down and asks if you want to stop the process) - plotly animated plots. 
  - consider clearing your local browser cache

## View error logs on the VM

```
cd /var/www/html/cache
ls *.Rout
tail AQ_Timeseries.Rout
```

Tail of Output:

```
+          }
+          #####################################
+       } # Close else statement
+    } # Close if/else statement
+ } # End num_runs loop
[1] "SELECT d.network,d.stat_id,s.lat,s.lon,LPAD(d.i,3,'0') as row,LPAD(d.j,3,'0') as col,d.ob_dates,d.ob_datee,d.ob_hour,d.month , d.NH4_ob, d.NH4_mod, d.precip_ob, d.precip_mod ,d.POCode,s.state,s.county from  aqExample  as d, site_metadata as s  WHERE d.NH4_ob is not NULL and d.network='NADP' and s.stat_id=d.stat_id and d.ob_dates BETWEEN 20180601 and 20180831 and d.ob_datee BETWEEN 20180601 and 20180831 and (d.ob_hour >= 00 and d.ob_hour <= 23)  and (d.valid_code = 't' or d.valid_code = 'd' or d.valid_code = 'w' or d.valid_code = 'wi' or d.valid_code = 'wd' or d.valid_code = 'wa') ORDER BY ob_dates,ob_hour"
Error in `$<-.data.frame`(`*tmp*`, "ob_hour", value = 0) : 
  replacement has 1 row, data has 0
Calls: query_dbase -> $<- -> $<-.data.frame
Execution halted
```

Note, that this query failed as there is no observational data loaded for the NADP network. (scroll to the right to see the full contents of the log file.)

## Use the query by logging into the mysql database to understand what is missing

```
SELECT d.network,d.stat_id,s.lat,s.lon,LPAD(d.i,3,'0') as row,LPAD(d.j,3,'0') as col,d.ob_dates,d.ob_datee,d.ob_hour,d.month , d.SO4_ob, d.SO4_mod ,d.POCode,s.state,s.county from  aqExample  as d, site_metadata as s  WHERE (d.network='AQS_Hourly')  and s.stat_id=d.stat_id and d.ob_dates BETWEEN 20180601 and 20180831 and d.ob_datee BETWEEN 20180601 and 20180831 and (d.ob_hour >= 00 and d.ob_hour <= 23)  ORDER BY ob_dates,ob_hour limit 10;
```

Output

```
+------------+-----------+----------+------------+------+------+------------+------------+---------+-------+--------+---------+--------+-------+---------+
| network    | stat_id   | lat      | lon        | row  | col  | ob_dates   | ob_datee   | ob_hour | month | SO4_ob | SO4_mod | POCode | state | county  |
+------------+-----------+----------+------------+------+------+------------+------------+---------+-------+--------+---------+--------+-------+---------+
| AQS_Hourly | 060010007 | 37.68753 | -121.78422 | 148  | 035  | 2018-06-30 | 2018-06-30 |      16 |     6 |   NULL |    NULL | 1      | CA    | Alameda |
| AQS_Hourly | 060010007 | 37.68753 | -121.78422 | 148  | 035  | 2018-06-30 | 2018-06-30 |      16 |     6 |   NULL |    NULL | 3      | CA    | Alameda |
| AQS_Hourly | 060010007 | 37.68753 | -121.78422 | 148  | 035  | 2018-06-30 | 2018-06-30 |      16 |     6 |   NULL |    NULL | 6      | CA    | Alameda |
| AQS_Hourly | 060010009 | 37.74307 | -122.16993 | 149  | 032  | 2018-06-30 | 2018-06-30 |      16 |     6 |   NULL |    NULL | 1      | CA    | Alameda |
| AQS_Hourly | 060010009 | 37.74307 | -122.16993 | 149  | 032  | 2018-06-30 | 2018-06-30 |      16 |     6 |   NULL |    NULL | 3      | CA    | Alameda |
| AQS_Hourly | 060010011 | 37.81478 | -122.28235 | 150  | 032  | 2018-06-30 | 2018-06-30 |      16 |     6 |   NULL |    NULL | 1      | CA    | Alameda |
| AQS_Hourly | 060010011 | 37.81478 | -122.28235 | 150  | 032  | 2018-06-30 | 2018-06-30 |      16 |     6 |   NULL |    NULL | 3      | CA    | Alameda |
| AQS_Hourly | 060010012 | 37.79362 | -122.26338 | 150  | 032  | 2018-06-30 | 2018-06-30 |      16 |     6 |   NULL |    NULL | 1      | CA    | Alameda |
| AQS_Hourly | 060010012 | 37.79362 | -122.26338 | 150  | 032  | 2018-06-30 | 2018-06-30 |      16 |     6 |   NULL |    NULL | 3      | CA    | Alameda |
| AQS_Hourly | 060010013 | 37.86477 | -122.30274 | 150  | 032  | 2018-06-30 | 2018-06-30 |      16 |     6 |   NULL |    NULL | 1      | CA    | Alameda |
+------------+-----------+----------+------------+------+------+------------+------------+---------+-------+--------+---------+--------+-------+---------+
10 rows in set (59.217 sec)
```

```
SELECT d.network,d.stat_id,s.lat,s.lon,LPAD(d.i,3,'0') as row,LPAD(d.j,3,'0') as col,d.ob_dates,d.ob_datee,d.ob_hour,d.month , d.SO4_ob, d.SO4_mod ,d.POCode,s.state,s.county from  aqExample  as d, site_metadata as s  WHERE (d.network='NADP')  and s.stat_id=d.stat_id and d.ob_dates BETWEEN 20180601 and 20180831 and d.ob_datee BETWEEN 20180601 and 20180831 and (d.ob_hour >= 00 and d.ob_hour <= 23)  ORDER BY ob_dates,ob_hour limit 10;
```

Output:

```
+---------+---------+---------+-----------+------+------+------------+------------+---------+-------+--------+---------+--------+-------+------------+
| network | stat_id | lat     | lon       | row  | col  | ob_dates   | ob_datee   | ob_hour | month | SO4_ob | SO4_mod | POCode | state | county     |
+---------+---------+---------+-----------+------+------+------------+------------+---------+-------+--------+---------+--------+-------+------------+
| NADP    | SK20    | 52.0223 | -109.8616 | 262  | 139  | 2018-06-30 | 2018-07-31 |      17 |     7 |   NULL |    NULL | 1      | SK    | -999       |
| NADP    | SD08    | 43.9461 | -101.8552 | 182  | 181  | 2018-06-30 | 2018-07-31 |      17 |     7 |   NULL |    NULL | 1      | SD    | Jackson    |
| NADP    | GA20    | 32.0849 |  -81.9367 | 081  | 331  | 2018-06-30 | 2018-07-31 |      19 |     7 |   NULL |    NULL | 1      | GA    | Evans      |
| NADP    | PA42    | 40.6575 |  -77.9397 | 164  | 346  | 2018-07-02 | 2018-07-09 |       4 |     7 |   NULL |    NULL | 1      | PA    | Huntingdon |
| NADP    | WY99    |  43.873 | -104.1917 | 182  | 166  | 2018-07-02 | 2018-07-10 |       6 |     7 |   NULL |    NULL | 1      | WY    | Weston     |
| NADP    | ME94    | 45.2436 |  -67.6308 | 224  | 402  | 2018-07-02 | 2018-07-10 |       7 |     7 |   NULL |    NULL | 1      | ME    | Washington |
| NADP    | NY10    | 42.2994 |  -79.3964 | 177  | 333  | 2018-07-02 | 2018-07-10 |       7 |     7 |   NULL |    NULL | 1      | NY    | Chautauqua |
| NADP    | ME00    | 46.8675 |  -68.0134 | 237  | 395  | 2018-07-02 | 2018-07-10 |      12 |     7 |   NULL |    NULL | 1      | ME    | Aroostook  |
| NADP    | SD04    | 43.5577 |  -103.484 | 179  | 170  | 2018-07-02 | 2018-07-10 |      13 |     7 |   NULL |    NULL | 1      | SD    | Custer     |
| NADP    | WA24    | 46.7606 | -117.1847 | 221  | 086  | 2018-07-02 | 2018-07-10 |      14 |     7 |   NULL |    NULL | 1      | WA    | Whitman    |
+---------+---------+---------+-----------+------+------+------------+------------+---------+-------+--------+---------+--------+-------+------------+
10 rows in set (0.036 sec)
```





