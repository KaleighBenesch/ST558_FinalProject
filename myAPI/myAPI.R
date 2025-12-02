# ST 558: Final Project - plumber API
# This is a Plumber API. You can run the API by clicking the 'Run API' button above.
#

library(plumber)
library(tidyverse)
library(tidymodels)
library(janitor)


#* @apiTitle Diabetes Prediction API
#* @apiDescription Plumber example, as it relates to a diabetes data set..

################################################################################
# Load and process the data
diabetes_data <- read_csv("../diabetes_binary_health_indicators_BRFSS2015.csv")

# Factor Conversion
diabetes_data <- diabetes_data |>
  mutate(Diabetes_binary = as.factor(Diabetes_binary),
         HighBP = as.factor(HighBP),
         HighChol = as.factor(HighChol),
         CholCheck = as.factor(CholCheck),
         Smoker = as.factor(Smoker),
         Stroke = as.factor(Stroke),
         HeartDiseaseorAttack = as.factor(HeartDiseaseorAttack),
         PhysActivity = as.factor(PhysActivity),
         Fruits = as.factor(Fruits),
         Veggies = as.factor(Veggies),
         HvyAlcoholConsump = as.factor(HvyAlcoholConsump),
         AnyHealthcare = as.factor(AnyHealthcare),
         NoDocbcCost = as.factor(NoDocbcCost),
         GenHlth = as.factor(GenHlth),
         DiffWalk = as.factor(DiffWalk),
         Sex = as.factor(Sex),
         Age = as.factor(Age),
         Education = as.factor(Education),
         Income = as.factor(Income))

# Clean names
diabetes_data <- diabetes_data |>
  clean_names()
################################################################################

# Fit best model on full test set

tree_recipe <- recipe(diabetes_binary ~ high_bp + phys_activity + age + income + education, data = diabetes_train) |> 
  step_dummy(all_nominal_predictors())

tree_mod <- decision_tree(tree_depth = 15,
                          min_n = 10,
                          cost_complexity = 1e-10) |>
  set_engine("rpart") |>
  set_mode("classification")

# Create our workflow.
tree_wkf <- workflow() |>
  add_recipe(tree_recipe) |>
  add_model(tree_mod)

# Fit to entire data set

final_tree_fit <- tree_wkf |>
  fit(data = diabetes_data)

################################################################################

# Default values for missing inputs

default_vals <- list(
  high_bp = names(which.max(table(diabetes_data$high_bp))),
  phys_activity = names(which.max(table(diabetes_data$phys_activity))),
  age = names(which.max(table(diabetes_data$age))),
  income = names(which.max(table(diabetes_data$income))),
  education = names(which.max(table(diabetes_data$education)))
)

################################################################################

# API Endpoints

# /pred for the pred endpoint

#* Predict probability of diabetes.
#* @param high_bp High blood pressure? (No: 0 or Yes: 1)
#* @param phys_activity Physically active? (No: 0 or Yes: 1)
#* @param age Age category? (1–13)
#* @param income Income category? (1–8)
#* @param education Education level? (1–6)
#* @get /pred
function(high_bp = default_vals$high_bp,
         phys_activity = default_vals$phys_activity,
         age = default_vals$age,
         income = default_vals$income,
         education = default_vals$education) {
  
  new_obs <- tibble(
    high_bp = as.factor(high_bp),
    phys_activity = as.factor(phys_activity),
    age = as.factor(age),
    income = as.factor(income),
    education = as.factor(education)
  )
  
  pred <- predict(final_tree_fit, new_obs, type = "prob")
  
  list(
    input = new_obs,
    probability_diabetes = pred$.pred_1
  )
}

################################################################################
# Three example function calls

# http://127.0.0.1:25723/pred?high_bp=0&phys_activity=1&age=5&income=7&education=4
# http://127.0.0.1:25723/pred?high_bp=1&income=3
# http://127.0.0.1:25723/pred?phys_activity=1

################################################################################
# /info for the info endpoint

function() {
  list(name = "Kaleigh Benesch",
       github_pages = "rendered github pages site")
}

################################################################################
# /confusion for the confusion endpoint
# This endpoint should produce a plot of the confusion matrix for our model fit.
# This compares the predictions from the model to the actual values from the data set.



