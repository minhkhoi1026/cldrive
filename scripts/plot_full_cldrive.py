import pandas as pd
import matplotlib.pyplot as plt

csv_file = 'test_cldrive.csv'  
df = pd.read_csv(csv_file)

df['num_work_groups'] = df['global_size'] / df['local_size_x']

# Plot the data as points
plt.figure(figsize=(10, 6))
plt.scatter(df['num_work_groups'], df['kernel_time_ns'], marker='o')

plt.xlabel('# work-groups')
plt.ylabel('Exe Time')
plt.title('Exe Time vs # work-groups')
plt.grid(True)

# Save the plot as a .png file
output_path = './execution_time_plot.png'
plt.savefig(output_path)

print(f"Plot saved to {output_path}")
