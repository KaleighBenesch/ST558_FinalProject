# ST558_FinalProject

### Big Idea

Here, we will create a vignette about selecting a predictive model. We will make that model available as an API and save that in a docker image that other users can run and access!

#### About the Data

The dataset we will be using throughout this project is the "diabetes _ binary _ health _ indicators _ BRFSS2015.csv" dataset, which is a cleaned dataset of 253,680 survey responses to the CDC's Behavioral Risk Factor Surveillance System (BRFSS2015) for the year of 2015. The survey collects responses from many Americans on health-related risk behaviors, chronic health conditions, and the use of preventative services. The target variable `Diabetes_binary` has 2 classes: 0 for no diabetes and 1 for diabetes/prediabetes. This dataset has 21 feature variables and is not balanced. The main predictor variables that we will be considering today are high blood pressure, physical activity, age, and income.
