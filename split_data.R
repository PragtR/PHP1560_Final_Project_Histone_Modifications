library(dplyr)

#' Split the data into training and testing sets
#' 
#' @description splits data to make subsets used for training and testing
#'
#' @param df A cleaned and chromosome-filtered dataframe
#' @param label_col Name of the label column ("mre_labels")
#' @param prop Proportion of data to use for training
#' @return A list containing train and test dataframes
#' 
split_data <- function(df, label_col, prop) {
  
  set.seed(123)
  
  df_split <- initial_split(df,
                            prop = prop,
                            strata = !!sym(label_col)) #Stratified split
  
  train_df <- training(df_split)
  test_df  <- testing(df_split)
  
  return(list(train = train_df, test = test_df))
}