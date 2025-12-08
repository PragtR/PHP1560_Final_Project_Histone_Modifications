# Binary Logistic Regression Model Pipeline for MRE Prediction Task for Dosage Compensation in Drosophila 

Background:
Male Drosophilia have only one X chromosome, while females have two. To compensate, males use the MSL (Male-Specific Lethal) complex to dramatically increase transcription on the single X chromosome and these MSL complex binds to specific DNA motifs called MREs (MSL Recognition Elements), which is what we will try to predict through our model.

Project Details:
This project builds a Binary Logistic Regression model pipeline to test whether histone modification patterns can predict:
1. which genomic bins contain MREs
2. whether a model trained on the X chromosome can generalize to autosomes

Running the pipeline:
1. Make sure the data file is in your project folder / specify the path on "main.R"
2. Make sure all the scripts are on the same folder.
3. Run the file "main.R" after changing the parameters of the functions based on your needs.

The script will automatically:
- load and clean the data filter to one chromosome (using preprocess.R script)
- split into train/test (using split_data.R script)
- train the model (using train_model.R script)
- evaluate performance on test data (using evaluate_model.R script)
- run cross-chromosome tests (using cross_chromosome.R script)
- generate ROC and PR curves + barplots for cross-chromosome tests metrics and saves  (using plotting.R script)

4. View plots on the "results" folder that will be created in your project folder

References:
- https://medium.com/the-researchers-guide/modelling-binary-logistic-regression-using-tidymodels-library-in-r-part-1-c1bdce0ac055