library(vroom) # faster for reading delimited data

source (preprocess.R)

data_raw <- vroom("/Users/prottoyroy/Desktop/php1560/updated_histone_mods_and_GA_factors.feature_matrix.1kb_res.txt", 
            delim = "\t", quote = "")

data_clean <- preprocess_data(data_raw)


