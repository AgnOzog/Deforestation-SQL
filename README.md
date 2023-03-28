# Project Deforestation Udacity

## Summary

The Deforestation project by Udacity is an analysis project that aims to use SQL queries to explore a dataset on global deforestation, with the goal of identifying the major causes of deforestation and proposing solutions. The project provides a dataset containing information on global forest cover, deforestation rates, and drivers of deforestation, such as agriculture, logging, and mining. The project requires the use of SQL to query the dataset and Jupyter Notebook to visualize the results. The project also provides guidance on the steps involved in performing the analysis, including data cleaning, exploratory data analysis, and data visualization. The project culminates in a report that summarizes the findings and proposes solutions to mitigate deforestation.

### Introduction - Udacity -

You're data analyst for ForestQuery, a non- profit organization, on a mission to reduce deforestation around the world and which raises awareness about this important envirionmental topioc.

You executive derector and her leadership team members are looking to understand which countries and regions around the world seem to have forests that have been shrinking in size, and also whih countries and regions have the most significant foprest area, both in terms of amount and personnel allocation to achieve the largest impact with the precious few resources that the organizations has at its disposal.

You've been able to find tables of data online dealing with forestation as well as total land area and region groupings, and you're brought these tables together into database that you'd like to query to answer some of the most important questions in preparation for meeting, you'd like to prepare and disseminate a report for the leadership team that uses complete sentences to help them understand the global deforestation overview between 1990 and 2016.

### Steps to complete:

1. Create a **View** called **'forestation'** by joinning all three rtables - **forest_area, land_area** and **regions** in the workspace.
2. The **forest_area** and **land_area** tables *join* on both **country_code** AND **year**.
3. The **regions** tabe joins these based on only **country_code**.
4. In the 'forestation' View, include the following: 
  - **All of the collumns of the orgin tables**
  - A **new column** that provides the **percent of the land area that is designated as forest.**

5. *Keep in mind* thta the column **forest_are_sqkm** in the forest_area table and the **land_area_sqmi** in the land_area table are in **different units (square kilometers and square mioles respectively),** so an adjustment will need to be made in the calculation you write (1sq mi = 2.59sq km) 
      
