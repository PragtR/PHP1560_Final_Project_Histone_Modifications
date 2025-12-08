#'Plot curves
#'
#'@description plots AUROC and AUPRC curves for evaluation of performance
#'
#'@param evaluation the list containing the auroc and auprc data (output of evaluate_model function)
#'@return nothing to return, but plots curves 
plot_curves <- function(evaluation) {
  
  roc_data <- evaluation$auroc_data
  auroc_val <- round(evaluation$auroc$.estimate, 3)
  pr_data <- evaluation$auprc_data
  auprc_val <- round(evaluation$auprc$.estimate, 3)
  
  roc_plot <- ggplot(roc_data) +
    geom_line(aes(x = 1 - specificity,
                  y = sensitivity),
              size = 1.2,
              color = "blue") +
    geom_abline(linetype = "dashed") +
    labs(x = "False Positive Rate",
         y = "True Positive Rate",
         title = paste0("ROC Curve (AUROC = ", auroc_val, ")")) +
    theme_minimal() +
    theme(legend.position = "none")
  
  pr_plot <- ggplot(pr_data) +
    geom_line(aes(x = recall,
                  y = precision),
              size = 1.2,
              color = "red") +
    labs(x = "Recall",
         y = "Precision",
         title = paste0("Precision–Recall Curve (AUPRC = ", auprc_val, ")")) +
    theme_minimal() +
    theme(legend.position = "none")
  
  roc_plot + pr_plot + plot_layout(ncol = 2)
}

#' Plotting metrics for cross model
#' 
#' @description plots histograms for a given metric for the cross evaluated model
#' 
#' @param cross_model_metrics A df containing the metrics of the cross trained model. The output of cross_chr_experiment
#' @param metric A string containing the name of the metric to plot
#' @param title A string for the title of the plot
#' 
#' @return nothing to return, but plots histograms of the metric for each test chromosome
plot_metric_cross_model <- function(cross_model_metrics, metric, title) {
  metrics <- cross_model_metrics[[metric]]
  ymin <- max(min(metrics) - 0.1, 0)
  ymax <- min(max(metrics) + 0.1, 1)
  
  ggplot(cross_model_metrics) +
    geom_col(aes(x = test_chr, y = .data[[metric]]),
             color = "blue",
             fill = "blue",
             alpha = 1) +
    labs(x = "Test chromosome",
         y = metric,
         title = title) +
    coord_cartesian(ylim = c(ymin, ymax)) +
    theme_minimal()
}