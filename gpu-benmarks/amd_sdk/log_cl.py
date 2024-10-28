import os
import zipfile
import shutil

# Define the paths
zip_folder = './'  # Folder containing the .zip files
destination_folder = 'dataset'  # Folder where .cl files will be copied

# Create the destination folder if it doesn't exist
os.makedirs(destination_folder, exist_ok=True)

# Iterate over all files in the zip_folder
for root, dirs, files in os.walk(zip_folder):
    print(f"root, dirs : {root}, {dirs}")
    if root == "./dataset" :
        continue 
    for file in files:
        if file.endswith('.cl'):
            # Full path of the .cl file
            cl_file_path = os.path.join(root, file)
            
            # Copy the .cl file to the destination folder
            shutil.copy(cl_file_path, destination_folder)

print(f"All .cl files have been copied to {destination_folder}")
