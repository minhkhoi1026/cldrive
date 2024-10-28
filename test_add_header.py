import os
import re

import re

def extract_macros(header_file):
    """ 
    Extract all #define macros from a header file, including multi-line macros with or without line continuation.
    """
    # Regular expression pattern to match single-line (//) and multi-line (/* */) comments
    comment_pattern = r"(//.*?$|/\*.*?\*/)"
    
    with open(header_file, 'r', encoding='latin-1') as file:
        content = file.read()
    
    # Remove comments
    content_without_comments = re.sub(comment_pattern, "", content, flags=re.DOTALL | re.MULTILINE)
    
    # Regular expression to capture #define macros including multi-line macros with line continuation
    define_pattern = r"""
        (?m)                           # Multiline mode
        ^#define\s+                    # Match #define followed by spaces
        (\S+)\s*                       # Capture the macro name
        (                              # Start of the macro body capture group
            (?:                        # Non-capturing group for body
                [^\n]*?               # Any characters except newlines (for single-line macros)
                (?:                   # Start of optional group for multi-line
                    \\                 # Line continuation character
                    \s*\n             # Optional spaces followed by a newline
                    [^\n]*?           # Any characters except newlines (for the next line)
                )*                    # Repeat for additional lines
            |                          # OR
            \{[^{}]*\}                 # Match a block enclosed in braces (for macros with {})
            |                          # OR
            \([^\)]*\)                 # Match a function-like macro (with parentheses)
        )*                              # The entire body can be repeated
        (?:                             # Non-capturing group for optional ending
            \\                         # Ending with a line continuation character
        )?                             # Optional line continuation at the end
        \s*$                           # End of line
    """
    
    # Extract all macros
    macros = re.findall(define_pattern, content_without_comments, flags=re.DOTALL | re.VERBOSE)
    
    # Optional: Write back the content without comments
    with open(header_file, 'w', encoding='latin-1') as file:
        file.write(content_without_comments)
    
    return [macro[0] for macro in macros]  # Return just the macro names

def insert_include(kernel_file, include_line):
    """
    Insert an #include statement at the top of a kernel file.
    """
    pattern = r"(//.*?$|/\*.*?\*/)"
    with open(kernel_file, 'r', encoding='latin-1') as file:
        content = file.read()
    content_without_comments = re.sub(pattern, "", content, flags=re.DOTALL | re.MULTILINE)
    with open(kernel_file, 'w', encoding='latin-1') as file:
        file.write(content_without_comments)

    # insert
    with open(kernel_file, 'r') as file:
        lines = file.readlines()
    
    # If the include is already there, skip
    if any(include_line in line for line in lines):
        return

    # Insert #include at the top
    lines.insert(0, include_line + '\n')
    
    with open(kernel_file, 'w') as file:
        file.writelines(lines)

def process_folders(base_dir, new_header_name="macros.hpp"):
    """
    Process all folders in the base directory, extract macros from .hpp files,
    and insert the new header file into corresponding .cl files.
    """
    macros = []

    # Traverse the directory structure
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith(".hpp") or file.endswith(".h") or file.endswith(".cpp"):
                header_file = os.path.join(root, file)
                # Extract macros from the header file
                macros.extend(extract_macros(header_file))
            elif file.endswith(".cl"):
                kernel_file = os.path.join(root, file)
                # Insert #include "macros.hpp" into the .cl file
                insert_include(kernel_file, f'#include "{new_header_name}"')

    # Write all extracted macros into the new header file
    new_header_path = os.path.join(base_dir, new_header_name)
    with open(new_header_path, 'w') as new_header:
        for macro in macros:
            new_header.write(macro + '\n')

    print(f"All macros written to {new_header_path}")

base_directory = "gpu-benmarks/shoc/src/opencl"  
process_folders(base_directory)
