#' Preprocess the data for MRE classification
#'
#' Removes unused columns, converts the MRE label column to a factor,
#' and drops any rows containing missing values.
#'
#' @param df A data frame containing the raw data.
#' @return A cleaned data frame ready for downstream analysis.

preprocess_data <- function(df) {
  
  # Columns that should not be used as features
  drop_cols <- c("bin1_id", "start", "end", "seq", "gene_labels")
  
  # Drop unnecessary columns
  df <- subset(df, select = -all_of(drop_cols))
  
  # Convert label to factor (important for classification)
  df$mre_labels <- as.factor(df$mre_labels)
  
  # Remove rows with NA values
  df <- na.omit(df)
  
  return(df)
}