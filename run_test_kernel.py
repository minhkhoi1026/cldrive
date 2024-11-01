import csv
import subprocess

# Specify the path to your CSV file
csv_file_path = 'kernel_path_folder/shoc_1D_kernels.csv'  # Update this to your actual CSV path

# Command template
command_template = './bazel-bin/gpu/cldrive/cldrive --srcs={} --cl_build_opt="-D N_GP=16"'

def run_commands_from_csv(csv_file):
    # Read the kernel paths from the CSV file
    with open(csv_file, mode='r') as file:
        reader = csv.reader(file)
        for row in reader:
            #print(f"row : {row}")
            kernel_path = row[0]  # Assuming the kernel path is in the first column
            # Construct the command with the current kernel path
            if kernel_path.count('level2') >= 0:
                print(kernel_path)
                command = command_template.format(kernel_path)
                # print(f"Executing command: {command}")
                try:
                    # Execute the command
                    subprocess.run(command, shell=True, check=True)
                except subprocess.CalledProcessError as e:
                    print(f"Error executing command: {e}")

if __name__ == "__main__":
    run_commands_from_csv(csv_file_path)
