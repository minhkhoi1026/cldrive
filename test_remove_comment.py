import os
import re

def remove_comments_from_file(file_path):
    # Regular expression pattern to match single-line (//) and multi-line (/* */) comments
    pattern = r"(//.*?$|/\*.*?\*/)"
    
    # Open the file, read its contents
    with open(file_path, 'r', encoding='latin-1') as file:
        content = file.read()

    # Use re.sub to remove the comments
    content_without_comments = re.sub(pattern, "", content, flags=re.DOTALL | re.MULTILINE)

    # Write the modified content back to the file
    with open(file_path, 'w', encoding='latin-1') as file:
        file.write(content_without_comments)

def remove_comments_in_folder(folder_path):
    # Traverse through each file in the folder
    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith(".cl"):  # Assuming OpenCL files have the .cl extension
                file_path = os.path.join(root, file)
                print(f"Processing file: {file_path}")
                remove_comments_from_file(file_path)

if __name__ == "__main__":
    folder_path = "amd_sdk/dataset"  # Replace with the path to your folder
    remove_comments_in_folder(folder_path)
