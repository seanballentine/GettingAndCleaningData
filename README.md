# Getting and Cleaning Data: Course Project
This repository holds the analysis file for the final project in the Coursera course 'Getting and Cleaning Data'

# File Description
run_analysis.R

1) The program downloads, unzips and reads in the raw data
2) The program renames the columns of the different tables read in
3) Since we are only collecting mean and standard deviation data we restrict the measurements to the necessary columns
4) We join the datasets together into one large dataset with subject and activity information attached
5) We reshape and summarise the data to get averages for each type of measurement by subject and activity
6) The resulting tidy dataset is saved
