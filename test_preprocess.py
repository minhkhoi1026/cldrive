import os
import re
import random
import shutil
import json
import random
import Levenshtein
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
    # Get a list of  .cl, .h, and .hpp files in the folder and subdirectories
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

def copy_kernels_to_new_folder(selected_kernels, dest_folder):
    os.makedirs(dest_folder, exist_ok=True)
    
    for kernel_path in tqdm(selected_kernels.keys(), desc="Copying selected kernels"):
        kernel_name = os.path.basename(kernel_path)
        new_kernel_path = os.path.join(dest_folder, kernel_name)
        
        shutil.copy2(kernel_path, new_kernel_path)
        print(f"Copied {kernel_path} to {new_kernel_path}")

if __name__ == "__main__":
    base_folder = 'gpu-benmarks/shoc'
    src_folder = 'gpu-benmarks/shoc/cl_dataset'  
    remove_comments_from_file(src_folder)
    selected_kernels = gen_kernels(src_folder) # filter 2,3D and duplicated kernels
    dest_folder = os.path.join(base_folder, "1D_cl_dataset")  
    copy_kernels_to_new_folder(selected_kernels, dest_folder)

    # kernel_folder = "amd_kernel_execution_results"
    # # Set to store unique kernel names (ignoring the timestamp)
    # unique_kernels = set()

    # # Iterate through each file in the folder
    # for filename in os.listdir(kernel_folder):
    #     if filename.endswith(".json"):  
    #         # Extract the kernel_file_name part by splitting on the last underscore
    #         kernel_name = "_".join(filename.split('_')[:-1])  # Remove the timestamp
    #         unique_kernels.add(kernel_name)
    # # Print the count of distinct kernels
    # print(f"Number of distinct kernels: {len(unique_kernels)}")

    # ====================== merge json =====================
    # json_folder = "amd_kernel_execution_results"
    # merged_data = []

    # # Read each JSON file in the folder and append its content to merged_data
    # count = 0
    # file_count = 0  # 
    # for json_filename in os.listdir(json_folder):
    #     if json_filename.endswith(".json"):
    #         json_filepath = os.path.join(json_folder, json_filename)
            
    #         try:
    #             with open(json_filepath, 'r') as f:
    #                 data = json.load(f)
    #                 merged_data.append(data)
    #             file_count += 1
    #         except json.JSONDecodeError:
    #             count += 1
    #             print(f"Error parsing JSON file: {json_filepath}")

    # # Save the merged data to a new JSON file
    # with open('amd_merged_kernel_results.json', 'w') as f:
    #     json.dump(merged_data, f, indent=4)

    # print(f"Merged data {file_count} kernels saved to merged_kernel_results.json with {count} kernels found no runtime")
    