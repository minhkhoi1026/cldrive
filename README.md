# GEN SCALAR codeflow Overview

This repository contains several test scripts used for preprocessing, generating scalar values, and analyzing runtime for datasets of `.cl` kernel files. Below is an overview of each script and its functionality.

### Scripts

#### `test_preprocess.py`
- Purpose: Removes 2D, 3D and duplicated kernels + remove comment, which may contain non-utf8 in dataset.
- **Input**: : folder contain kernel code
- **Output** : csv file contain selected kernel paths

#### `test_utils.py`
- Purpose: Currently under development, aimed at simplifying code for the main script `test_run_mem_scalar_gen.py`.

#### `test_run_mem_scalar_gen.py`
- Purpose: Identifies scalar values in a dataset of `.cl` files.
  - **Input**: A csv from `test_preprocess.py` or any csv contain kernel path
  - **Output**: A JSON file structured as follows:
  ```json
  { 
    "kernel_path": "...", 
    "validity": false, 
    "scalar_strategy_found": [],
    "execution": {
      "scalars_type": [],
      "values": [],
      "runtime": 0
    }
  }
  ```

#### `test_gen_scalar.py`
- Purpose: Generates scalar values for each valid kernel.
  - **Input**: JSON file generated by `test_run_mem_scalar_gen.py`.
  - **Output**: Updates the `scalars_value` and `runtime` attributes in the JSON file.

#### `test_plot_time.py`
- Purpose: Plots runtime into a suitable chart for analysis.
