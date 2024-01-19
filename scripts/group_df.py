import json
import pandas as pd
import os
from tqdm import tqdm
from loguru import logger
import numpy as np

# Define the folder path where your CSV files are located
folder_path = "./backup-benchmark/success"

# Create an empty list to store the individual DataFrames
df_list = []

# Loop through the files in the folder and read them into DataFrames
for filename in tqdm(list(os.listdir(folder_path))):
    if filename.endswith(".csv"):
        file_path = os.path.join(folder_path, filename)
        df = pd.read_csv(file_path)
        # group by device,kernel,global_size,local_size_x,args_info
        aggr = {}
        aggr['kernel_time_ns'] = 'mean'
        aggr['outcome'] = lambda x: x.iloc[0]
        df = df.groupby(['device','kernel','global_size','local_size_x','args_info'])\
                .agg(aggr).reset_index()
        json_path = os.path.join("kernels1", "_".join(filename.split("_")[:-2]) + ".json")
        with open(json_path, 'r') as f:
            src = json.load(f)["src"]
        df["kernel_code"] = src
        df_list.append(df)
        

# Concatenate the individual DataFrames into one DataFrame
concatenated_df = pd.concat(df_list, ignore_index=True)

# Print the concatenated DataFrame
print(len(concatenated_df))

concatenated_df.to_csv('full_cldrive.csv', index=False)

outcome_counts = concatenated_df['outcome'].value_counts()

for category, count in outcome_counts.items():
    logger.info(f'{category}: {count}')
