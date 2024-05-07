import json
import pandas as pd
import os
from tqdm import tqdm
from loguru import logger
import numpy as np

#create parser
import argparse
parser = argparse.ArgumentParser(description='Group cldrive CSV files into one DataFrame')
parser.add_argument('--input_folder', '-i', type=str, default="./local/github-2M1/success", help="Input folder path")
parser.add_argument('--kernel_folder', '-k', type=str, default="./local/kernels", help="Path of the folder containing kernels source code")
parser.add_argument("--with_input_size", action="store_true", default=False, help="If the input size is included in the filename")
parser.add_argument("--output_path", "-o", type=str, default="local/github-2M1/grouped.csv", help="Output file name")
args = parser.parse_args()

# Define the folder path where your CSV files are located
result_path = args.input_folder
kernel_path = args.kernel_folder
save_path = os.path.dirname(args.output_path)
if not os.path.exists(result_path):
    raise FileNotFoundError(f"Folder {result_path} not found")
if not os.path.exists(kernel_path):
    raise FileNotFoundError(f"Folder {kernel_path} not found")
if not os.path.exists(save_path):
    print(f"Folder {save_path} not found, creating it...")
    os.makedirs(save_path)

# Create an empty list to store the individual DataFrames
df_list = []

def extract_info_from_filename(filename):
    if args.with_input_size:
        kernel_id, gsize, lsize, i = os.path.splitext(filename)[0].split("_")
        return kernel_id, int(gsize), int(lsize), int(i)
    else:
        kernel_id, gsize, lsize = os.path.splitext(filename)[0].split("_")
        return kernel_id, int(gsize), int(lsize)

# Loop through the files in the folder and read them into DataFrames
for filename in tqdm(list(os.listdir(result_path))):
    if filename.endswith(".csv"):
        file_path = os.path.join(result_path, filename)
        try:
            df = pd.read_csv(file_path)
        except Exception as e:
            print(f'kernel {file_path} failed to read csv!')
            raise e
        # group by device,kernel,global_size,local_size_x,args_info
        aggr = {}
        aggr['kernel_time_ns'] = 'mean'
        aggr['outcome'] = lambda x: x.iloc[0]
        df = df.groupby(['device','kernel','global_size','local_size_x','args_info'])\
                .agg(aggr).reset_index()
                
        kernel_id = extract_info_from_filename(filename)[0]
        kernel_filepath = os.path.join(kernel_path, kernel_id + ".cl")

        with open(kernel_filepath, 'r') as f:
            df["kernel_code"] = f.read()
        df_list.append(df)
        

# Concatenate the individual DataFrames into one DataFrame
concatenated_df = pd.concat(df_list, ignore_index=True)

# Print the concatenated DataFrame
print(len(concatenated_df))

concatenated_df.to_csv(args.output_path, index=False)

outcome_counts = concatenated_df['outcome'].value_counts()

for category, count in outcome_counts.items():
    logger.info(f'{category}: {count}')
