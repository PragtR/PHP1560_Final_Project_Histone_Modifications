library(vroom) # faster for reading delimited data

data_raw <- vroom("updated_histone_mods_and_GA_factors.feature_matrix.1kb_res.txt", 
            delim = "\t", quote = "")

data_clean <- preprocess_data(data_raw)