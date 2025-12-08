library(vroom)
library(dplyr)

#'Preprocess data
#'
#'@description reads and preprocesses the data
#'
#'@param data_path a string containing the file path to the data. Uses vroom which supports tab-delimited data
#'@param cols_to_drop a vector containing strings of the names of the columns you wish to drop, or remove from the data
#'@param label_col a string containing the name of the column in your data that holds the labels
#'@return a df containing the cleaned version of the data
#'
preprocess_data <- function(data_path, cols_to_drop, label_col) {
  
  df <- vroom(data_path, delim = "\t", quote = "")
  
  df <- df[, !(names(df) %in% cols_to_drop)]
  
  df <- na.omit(df)
  
  df[[label_col]] <- as.factor(df[[label_col]])
  
  return(df)
}

#'Filter dataset to keep bins from a single chromosome and make labels binary
#'
#'@description filters the dataset based on the chromosome of interest and makes the MRE labels binary
#'
#'@param df cleaned dataframe (output of preprocess_data)
#'@param chromosome a string of the name of a chromosome in the chr column. The model will only collect training data from this chromosome. eg "chrX", "chr2L"
#'@param label_col column name that contains the labels for classification
#'@return a dataframe filtered to the chromosome, with labels 0/1
#' 
filter_chromosome_data <- function(df, chromosome, label_col) {
  
  #subset by chromosome
  df_chr <- df[df$chr == chromosome, ]
  
  #Convert to character so comparisons work reliably
  labels <- as.character(df_chr[[label_col]])
  
  #Anything NOT "0" becomes "1"
  #This is more general instead of checking specifically for chrX. Other datasets might have weird labels, with this we assume anything that isnt a 0 is the positive class and assign is a 1
  df_chr[[label_col]] <- ifelse(labels == "0", "0", "1")
  
  #Return as factor
  df_chr[[label_col]] <- as.factor(df_chr[[label_col]])
  
  return(df_chr)
}