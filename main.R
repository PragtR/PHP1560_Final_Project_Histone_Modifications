library(vroom)
library(tidymodels)
library(dplyr)
library(themis)
library(ggplot2)
library(patchwork)

source("preprocess.R")
source("split_data.R")
source("train_model.R")
source("evaluate_model.R")
source("plotting.R")
source("cross_chromosome.R")

# Create results folder if not exists
if (!dir.exists("results")) dir.create("results")



####### END-TO-END PIPELINE for training the data on X chromosome #########


#Getting data
data <- preprocess_data("histone.txt",
  c("clamp", "gaf", "psq", "seq", "gene_labels"),
  "mre_labels"
)

#Further subsetting the data to a single chromosome
df_chromosome <- filter_chromosome_data(data, 
                                        chromosome = "chrX", 
                                        label_col = "mre_labels")

df_chromosome$mre_labels <- relevel(df_chromosome$mre_labels, ref = "0")

#Splitting data 
splits <- split_data(df_chromosome, label_col = "mre_labels", prop = 0.80)
train_data <- splits$train #training data
test_data  <- splits$test #testing data

#Training model
model <- train_model(train_data,                #putting the training data here
                     label_col = "mre_labels",
                     predictor_cols = c("h3k27ac","h3k27me3","h3k36me3",
                     "h3k4me1","h3k4me2","h3k4me3",
                     "h3k9me3","h4k16ac")
)

tidy(model)

#Evaluating the model
evaluation <- evaluate_model(model, test_data, label_col = "mre_labels")

#Plot ROC + Precision-recall curve
curve_plot <- plot_curves(evaluation)

# SAVE ROC + PR plot
ggsave("results/ROC_PR_plot.png", curve_plot, width = 10, height = 4)




############# CROSS CHROMOSOME #################

x_to_autosomal <- cross_chr_experiment(
  "chrX", 
  c("chr2L", "chr2R", "chr3L"), 
  RP2_data, 
  "mre_labels", 
  0.8,
  label_col = "mre_labels",
  predictor_cols = c("h3k27ac","h3k27me3","h3k36me3",
                     "h3k4me1","h3k4me2","h3k4me3",
                     "h3k9me3","h4k16ac")
)

autosomal_to_x <- cross_chr_experiment(
  "chr2L", 
  c("chrX", "chr2R", "chr3L"),
  RP2_data, 
  "mre_labels", 
  0.8,
  label_col = "mre_labels",
  predictor_cols = c("h3k27ac","h3k27me3","h3k36me3",
                     "h3k4me1","h3k4me2","h3k4me3",
                     "h3k9me3","h4k16ac")
)


# AUROC
p1 <- plot_metric_cross_model(
  x_to_autosomal, 
  "AUROC", 
  "AUROC for X to Autosomal model"
)
ggsave("results/x_to_autosomal_AUROC.png", p1, width = 6, height = 4)

# AUPRC
p2 <- plot_metric_cross_model(
  x_to_autosomal, 
  "AUPRC", 
  "AUPRC for X to Autosomal model"
)
ggsave("results/x_to_autosomal_AUPRC.png", p2, width = 6, height = 4)

# Accuracy
p3 <- plot_metric_cross_model(
  x_to_autosomal, 
  "Accuracy", 
  "Accuracy for X to Autosomal model"
)
ggsave("results/x_to_autosomal_Accuracy.png", p3, width = 6, height = 4)
