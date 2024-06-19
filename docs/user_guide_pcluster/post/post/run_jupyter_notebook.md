##  Run Jupyter Notebook to analyze difference between with DESID Emissions and the base case (no emission reduction)

1.  Change directories to the location of the Jupyter Notebook

```
cd /shared/pcluster-cmaq/qa_scripts/workshop
```

2. Switch to the .tcsh shell

```

/bin/tcsh
```

3. Run Jupyter Notebook (this may take a few minutes to run and to start the firefox browser)

```
jupyter notebook
```


4. Create Spatial Difference Plot

    a. Double Click on the Spatial_Plots_of_Ave_Conc_Differences.ipynb notebook

    b. In each cell you can use the 'shift return' or 'shift enter' to run each cell

    c. In the section "Set up your Inputs" you will use shift+enter, then enter the value, and then enter to submit the answer.

    d. View the plots within the Jupyter Notebook in cells after the plots have been generated

    e. Plot of Average SO2 Base (left plot) versus Average SO2 DESID REDUCE CMAQ

5. Create Timeseries Plot at Cell where PT_EGU emissions were reduced

    a. Double Click on the desid_timeseries.ipynb notebook
    b. In each cell you can use the 'shift return' or 'shift enter' to run each cell
    c. View the plots within the Jupyter Notebook in cells after the plots have been generated
    d. Plot comparing two time series, one for base case and one for DESID reduce case.

  ![Time Series Plot Comparison](../../../../qa_scripts/Timeseries_SO2_20171223_desid_4_1.png)
