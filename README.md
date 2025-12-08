# Binary Logistic Regression Model Pipeline for MRE Prediction Task for Dosage Compensation in Drosophila 

**Background:**
Male Drosophilia have only one X chromosome, while females have two. To compensate, males use the MSL (Male-Specific Lethal) complex to dramatically increase transcription on the single X chromosome. These MSL complex binds to specific DNA motifs called MREs (MSL Recognition Elements). Because the specificity of the MSL complex is flexible, the MRE motif is not a set motif and has some variability in the exact nucleotide sequence it is composed of. Epigenomic features that control the chromatin environment may play a role in determining where these MRE exists. Thus, we propose a logisitc regression model that is trained on ChIP-seq (epigenomic) data to predict the presence of these MREs in binned regions across chromosomes.

While we apply our logisitc regression model to this MRE prediction task, our pipeline is flexible to any binary classification prediction task using ChIP-seq data. Users can specify the column name that contains the labels for prediction, as well as column names that hold values for the predictors, and the pipeline will automatically build a logisitc regression model using their specified data.

**Project Details:**
This project builds a Multiple Logistic Regression model pipeline to test whether histone modification patterns can predict:
1. which genomic bins contain MREs
2. whether a model trained on the X chromosome can generalize to autosomes

**Running the pipeline:**
1. Make sure the data file is in your project folder / specify the path on "main.R"
2. Make sure all the scripts are in the same folder.
3. Run the file "main.R" after changing the parameters of the functions based on your needs. This script will automatically:
- load and clean the data filter to one chromosome (using preprocess.R script)
- split into train/test (using split_data.R script)
- train the model (using train_model.R script)
- evaluate performance on test data (using evaluate_model.R script)
- run cross-chromosome tests (using cross_chromosome.R script)
- generate ROC and PR curves + barplots for cross-chromosome tests metrics and saves  (using plotting.R script)

4. View plots in the "results" folder that will be created in your project folder

**Reference:**
- Duan, J., & Larschan, E. N. (2019). Dosage compensation: How to be compensated… or not? Current Biology, 29(23), R1229–R1231. https://doi.org/10.1016/j.cub.2019.09.065
- https://medium.com/the-researchers-guide/modelling-binary-logistic-regression-using-tidymodels-library-in-r-part-1-c1bdce0ac055
