library(tidymodels)
library(themis)

#'Train model
#'
#'@description fits data to a logistic regression model for binary classification.
#'@param train_df a df containing the training data
#'@param label_col a string, the name of the column that contains the labels
#'@param predictor_cols a vector of strings containing the names of the columns with predictors. eg. histone modifications
#'@param downsample a boolean indicating if the user wants to downsample the majority class in the training data. Recommended for datasets that are large but imbalanced. In our case, we opt for downsampling as we had ~4k (~20%) positive labels
#'@param class_weights a boolean indicating if the user wants to include class weights. Useful if the dataset is slightly imbalanced and you don't want to downsample, but still want the model to pay more attention to the minority class. Only checked if downsample is false
#'@return the fitted logisitc regression model
train_model <- function(train_df, label_col, predictor_cols,
                        downsample = TRUE, class_weights = FALSE) {
  
  #getting subsets of training data that contain the labels only and the predictors only 
  y <- train_df[[label_col]]
  x <- train_df[, predictor_cols, drop = FALSE]
  
  if (downsample) {
    
    #creating a flexible formula that allows for multiple predictors
    formula_str <- paste(label_col, "~", paste(predictor_cols, collapse = " + "))
    fm <- as.formula(formula_str)
    
    #preprocessing, setting predictors and outcomes
    recipe_obj <- recipe(fm, data = train_df) %>%
      step_downsample(all_of(label_col)) #downsampling here
    
    #creating the model
    model <- logistic_reg() %>%
      set_engine("glm") %>%
      set_mode("classification")
    
    #setting pipeline, combining the preprocess steps and model into a single object
    workflow_obj <- workflow() %>%
      add_recipe(recipe_obj) %>%
      add_model(model)
    
    #fitting the model
    fitted <- fit(workflow_obj, data = train_df)
    return(fitted)
  }
  else {
    if (class_weights) {
      curr_prop <- table(y)
      total <- sum(curr_prop)
      #common class weights formula is inversely proportional to classs size,
      #so the smaller the class size the larger the weight
      cw <- total / (2 * curr_prop)
      train_df$class_weights <- ifelse(y == names(cw)[2], cw[2], cw[1])
      
      model <- logistic_reg() %>%
        set_engine("glm") %>%
        set_mode("classification")
      
      fitted_model <- fit_xy(
        object = model,
        x = x,
        y = y,
        weights = train_df$class_weights
      )
      return(fitted_model)
    }
    else {
      model <- logistic_reg() %>%
        set_engine("glm") %>%
        set_mode("classification")
      
      fitted_model <- fit_xy(
        object = model,
        x = x,
        y = y
      )
      return(fitted_model)
    }
  }
}