library (tidymodels)

#'Evaluate model
#'
#'@description evaluates the trained model on the testing set
#'
#'@param model the fitted regression model
#'@param test_df the df containing the testing data
#'@param label_col the name of column containing the labels
#'@return a list containing metrics and data necessary for AUROC and AUPRC plots
evaluate_model <- function(model, test_df, label_col) {
  
  # Generate predictions
  preds <- predict(model, test_df, type = "class")
  preds_prob  <- predict(model, test_df, type = "prob")
  
  # Build tibble for yardstick
  results <- tibble(
    truth = test_df[[label_col]],
    estimate = preds$.pred_class,
    prob_1 = preds_prob$.pred_1
  )
  
  # Custom metric set
  custom_metrics <- metric_set(
    accuracy, sens, spec, precision, recall, f_meas, kap, mcc
  )
  
  # Compute metrics
  metrics_output <- custom_metrics(results, 
                                   truth = truth, 
                                   estimate = estimate,
                                   event_level = "second") #positive label is in the second level of the factor
  
  # Confusion matrix
  cm <- conf_mat(results, truth, estimate)
  
  #Adding functionality to return AUROC and AUPRC curves for plotting
  auroc <- roc_auc(results,
                   truth = truth,
                   prob_1,
                   event_level = "second")
  auprc <- pr_auc(results,
                  truth = truth,
                  prob_1,
                  event_level = "second")
  auroc_data <- roc_curve(results,
                          truth = truth,
                          prob_1,
                          event_level = "second")
  auprc_data <- pr_curve(results,
                         truth = truth,
                         prob_1,
                         event_level = "second")
  
  return(list(
    metrics = metrics_output,
    confusion_matrix = cm,
    results = results,
    auroc = auroc,
    auprc = auprc,
    auroc_data = auroc_data,
    auprc_data = auprc_data
  ))
}