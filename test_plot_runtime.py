import json
import numpy as np
import matplotlib.pyplot as plt
import os

# Load JSON data
json_file = "amd_merged_kernel_results.json"

# Function to safely convert a string that looks like a tuple into an actual tuple
def safe_eval(value):
    return eval(value) if isinstance(value, str) else value

# Dictionary to store runtimes for each distinct kernel
kernel_runtimes = {}

# Read the JSON file
with open(json_file, 'r') as f:
    records = json.load(f)

# Process each record
print(len(records))
for record in records:
    kernel_name = record["kernel"]
    runtime = record["runtime"]
    
    # Initialize list for runtimes if the kernel is not already in the dictionary
    if kernel_name not in kernel_runtimes:
        kernel_runtimes[kernel_name] = []
    
    # Append runtime value to the corresponding kernel's list
    kernel_runtimes[kernel_name].append(runtime)

print(len(kernel_runtimes))

# Calculate variance for each kernel
kernel_stds = {}

for kernel, runtimes in kernel_runtimes.items():
    if len(runtimes) > 1:  # Variance is meaningful when there are multiple values
        std = np.std(runtimes)
        kernel_stds[kernel] = std

# Extract variances to plot them into a histogram
std = list(kernel_stds.values())
print(len(std))

# #Calculate Q1 (25th percentile) and Q3 (75th percentile)
# Q1 = np.percentile(std, 25)
# Q3 = np.percentile(std, 75)
# IQR = Q3 - Q1  # Interquartile range

# # # Define outlier boundaries
# lower_bound = Q1 - 1.5 * IQR
# upper_bound = Q3 + 1.5 * IQR

# # # Remove outliers from the variances list
# clean_std = [var for var in std if lower_bound <= var <= upper_bound]
# print(len(clean_std))

plt.hist(std, bins=100 , edgecolor='black')
plt.xlabel('std of runtime')
plt.ylabel('Frequency')
plt.show()
plt.savefig("amd_std_test_100bins.png")