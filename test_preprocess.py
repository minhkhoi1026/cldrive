import os
import re
import random
import shutil
import json
import random
import Levenshtein
import argparse
from torch import unique
from tqdm import tqdm
""" Modify from utils.py as a preprocessing steps """

def filter_no_hook_kernel(kernel_dict):
    all_files = kernel_dict.keys()
    hookded_kernels = {}
    for kernel in tqdm(all_files):
        kernel_code = kernel_dict[kernel]
        hook_count = kernel_code.count('hook')
        if hook_count >=2 :
            hookded_kernels[kernel] = kernel_code
    return hookded_kernels

def remove_duplicate_kernels(kernels):
    """
    Remove duplicate kernels from a dict of {kernel_path: kernel_code}
    """
    unique_kernels = {}
    for kernel in tqdm(kernels):
        is_duplicate = False
        kernel_code = kernels[kernel]
        for unique_kernel in unique_kernels:
            unique_kernel_code = unique_kernels[unique_kernel]
            if Levenshtein.ratio(kernel_code, unique_kernel_code, score_cutoff=0.95) != 0:
                is_duplicate = True
                break
        if not is_duplicate:
            unique_kernels[kernel] = kernel_code
    return unique_kernels


def detect_kernel_dimensions(kernel_code):
    dimensions = {
        "3D-global": ["get_global_id(2)", "get_global_size(2)", 
                      "get_group_id(2)", "get_num_groups(2)", "get_global_offset(2)"],
        "2D-global": ["get_global_id(1)", "get_global_size(1)", 
                      "get_group_id(1)", "get_num_groups(1)", "get_global_offset(1)"],
        "3D-local": ["get_local_id(2)", "get_local_size(2)"],
        "2D-local": ["get_local_id(1)", "get_local_size(1)"],
    }

    result = ""
    for dim, patterns in dimensions.items():
        if any(pattern in kernel_code for pattern in patterns):
            result += " " + dim
    if result == "":
        result = "1D"

    return result.strip()

def remove_multi_dimension_kernels(kernels):
    """
    Remove multi-dimensional kernels from a dict of {kernel_path: kernel_code}
    """
    unique_kernels = {}
    for kernel in tqdm(kernels):
        kernel_code = kernels[kernel]
        if detect_kernel_dimensions(kernel_code) == "1D":
            unique_kernels[kernel] = kernel_code
    return unique_kernels

def remove_comments_from_file(folder_path):
    # list of all  .cl, .h, and .hpp files in the folder and subdirectories
    files_to_process = []
    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith(".cl") or file.endswith(".h") or file.endswith(".hpp"):
                files_to_process.append(os.path.join(root, file))
                
    # Regular expression pattern to match single-line (//) and multi-line (/* */) comments
    pattern = r"(//.*?$|/\*.*?\*/)"
    
    # Process each file with a progress bar
    for file_path in tqdm(files_to_process, desc="Removing comments from files"):
        with open(file_path, 'r', encoding='latin-1') as file:
            content = file.read()
        content_without_comments = re.sub(pattern, "", content, flags=re.DOTALL | re.MULTILINE)
        with open(file_path, 'w', encoding='latin-1') as file:
            file.write(content_without_comments)

def gen_kernels(src_folder):
    '''
    Filter 2d, 3d + duplicated + no_hook kernels
    '''
    all_kernels = [] #kernel_path
    for root, _, files in os.walk(src_folder):
        for file in files:
            if file.endswith(".cl"):
                all_kernels.append(os.path.join(root, file))
    print(f"Number of kernels in {src_folder}: {len(all_kernels)}")

    # build kernel_path - kernel_code dict
    kernels = {}
    for kernel_path in all_kernels:
        with open(os.path.join(kernel_path)) as f:
            kernels[kernel_path] = f.read()

    # choose only 1D kernel
    print(f'Removing multi-dimensional kernels...')
    selected_kernels = remove_multi_dimension_kernels(kernels)
    print(f'Removed multi-dimensional kernels. Number of kernels: {len(selected_kernels)}')
    # remove duplicate kernels
    print(f'Removing duplicate kernels...')
    selected_kernels = remove_duplicate_kernels(selected_kernels)
    print(f'Removed duplicate kernels.\n Number of kernels: {len(selected_kernels)}')
    # #remove no-hook-kernels
    # selected_kernels = filter_no_hook_kernel(selected_kernels)
    # print(f'Removed kernels that hook function does not work \n. Number of kernels: {len(selected_kernels)}')
    return selected_kernels

def create_csv(selected_kernels, kernel_path_csv):
    with open(kernel_path_csv, 'w') as f:
        f.write("kernel_path\n")
        for kernel_path,kernel_code in selected_kernels.items():
            f.write(f"{kernel_path}\n")
    print(f"Saved kernel paths to {kernel_path_csv}")

if __name__ == "__main__":
    # Argument parser for dataset and src_folder
    parser = argparse.ArgumentParser(description="Process kernel files and generate CSV.")
    parser.add_argument('--dataset', type=str, default="", help="Name of the dataset.")
    parser.add_argument('--src_folder', type=str, default="", help="Path to the source folder containing kernel files.")
    args = parser.parse_args()
    
    os.makedirs("kernel_path_folder", exist_ok=True)
    dataset = args.dataset
    src_folder = args.src_folder 

    remove_comments_from_file(src_folder)
    selected_kernels = gen_kernels(src_folder) # filter 2,3D and duplicated kernels
    kernel_path_csv = os.path.join("kernel_path_folder",f"{dataset}_1D_kernels.csv" )
    create_csv(selected_kernels, kernel_path_csv)