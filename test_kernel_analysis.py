import csv
import os
import shutil 
import pandas as pd
import ast 

FOLDER_5K = "test_kernels-modified"
FOLDER_NO_STRATEGY = "test_no_strategy_kernels"

def check_sha_in_file(file_content):
    """Check if the file content contains the string 'SHA'."""
    return 'sha' in file_content


def read_file_content(file_name):
    """Read the content of a file in the current folder."""
    try:
        with open(file_name, 'r') as file:
            return file.read()
    except FileNotFoundError:
        print(f"File {file_name} not found.")
        return None

def process_csv_file(kernel_df):
    """Process the CSV file, check for 'SHA' in each kernel file."""

    print(f"Total rows in the CSV file: {len(kernel_df)}")

    sha_count = 0
    no_strategy_count = 0
    for index, row in kernels_df.iterrows():
        kernel_path = row['kernel_path']
        file_name = os.path.basename(kernel_path)
        file_path = os.path.join(FOLDER_5K,file_name)
        # Read the content 
        file_content = read_file_content(file_path)
        # if file_content:
        kernel_strategy = ast.literal_eval(row["valid_args_set"])
        if len(kernel_strategy) == 0:
            cp_path = os.path.join(FOLDER_NO_STRATEGY,file_name)
            shutil.copy(file_path, cp_path)
            no_strategy_count += 1  
            print(f"Copy file {file_path} to {FOLDER_NO_STRATEGY} okay !!!")
            # if check_sha_in_file(file_content):
            #     print(f"'SHA' found in file: {file_name}")
            #     sha_count += 1

    print(f"{sha_count} kernels in {no_strategy_count} kernels with no strategies")

if __name__ == "__main__":
    if not os.path.exists(FOLDER_NO_STRATEGY):
        os.makedirs(FOLDER_NO_STRATEGY)
    file_success_kernel = "test_valid_results.csv"
    kernels_df = pd.read_csv(file_success_kernel)
    process_csv_file(kernels_df)
