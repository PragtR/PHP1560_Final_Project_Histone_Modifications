#' Cross chromosome experiment
#' 
#' @description Performs cross chromosome experiment where the model is trained on one chromosome and tested on other chromosomes 
#' 
#' @param train_chr a string containing the name of the chromosome you want the model to be trained on
#' @param test_chrs a vector of strings containing the chromosomes you want the model to be tested on. 
#' @param data a df containing the full data
#' @param label a string containing the column name of the labels
#' @param prop a numeric value between 0 and 1. The proportion of the data you want to set aside for training. Testing will be 1 - prop. 
#' @return a df containing the metrics for accuracy, auroc, and auprc for each pair of train and test chromosome
cross_chr_experiment <- function(train_chr, test_chrs, data, 
                                 label, prop, label_col, predictor_cols) {
  
  #getting filtered data for the train chromosome
  df_train_chr <- filter_chromosome_data(data,
                                         chromosome = train_chr,
                                         label_col = label)
  df_train_chr[[label]] <- relevel(df_train_chr[[label]], ref = "0")
  
  #initializing empty df to return
  results_df <- data.frame(train_chr = character(),
                           test_chr = character(),
                           Accuracy = numeric(),
                           AUROC = numeric(),
                           AUPRC = numeric())
  
  #looping through each test chromosome in test_chrs
  for (chr in test_chrs) {
    df_test_chr <- filter_chromosome_data(data,
                                          chromosome = chr,
                                          label_col = label)
    df_test_chr[[label]] <- relevel(df_test_chr[[label]], ref = "0")
    
    #training data on train chrom but testing data from test chrom
    train_data <- split_data(df_train_chr, label_col=label, prop=prop)$train
    test_data <- split_data(df_test_chr, label_col=label, prop=prop)$test
    
    model <- train_model(train_data, label_col=label_col, predictor_cols=predictor_cols)
    tidy(model)
    eval_cross <- evaluate_model(model, test_data, label_col=label_col)
    metrics <- eval_cross$metrics
    acc <- metrics[metrics$.metric == "accuracy", ".estimate"][[1]]
    auroc <- (eval_cross$auroc)$.estimate
    auprc <- (eval_cross$auprc)$.estimate
    
    #appending metrics to df
    result <- data.frame(train_chr = train_chr,
                         test_chr = chr,
                         Accuracy = acc,
                         AUROC = auroc,
                         AUPRC = auprc)
    results_df <- rbind(results_df, result)
  }
  return(results_df)
}