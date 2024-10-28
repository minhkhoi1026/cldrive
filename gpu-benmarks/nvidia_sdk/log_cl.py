import os
import zipfile
import shutil

# Define the paths
zip_folder = './'  # Folder containing the .zip files
destination_folder = 'dataset'  # Folder where .cl files will be copied

# Create the destination folder if it doesn't exist
os.makedirs(destination_folder, exist_ok=True)

# Iterate over all files in the zip_folder
for filename in os.listdir(zip_folder):
    if filename.endswith('.zip'):
        # Full path of the zip file
        zip_path = os.path.join(zip_folder, filename)
        
        # Extract the zip file into a temporary directory
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            extract_folder = os.path.join(zip_folder, os.path.splitext(filename)[0])
            zip_ref.extractall(extract_folder)
            
            # Walk through the extracted folder and find .cl files
            for root, dirs, files in os.walk(extract_folder):
                for file in files:
                    if file.endswith('.cl'):
                        # Full path of the .cl file
                        cl_file_path = os.path.join(root, file)
                        
                        # Copy the .cl file to the destination folder
                        shutil.copy(cl_file_path, destination_folder)

print(f"All .cl files have been copied to {destination_folder}")
