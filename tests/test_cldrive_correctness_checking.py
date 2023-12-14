import numpy as np
from cldrive_correctness_checking import (
    cldrive_check_correctness, 
    run_kernel_list,
    run_one_kernel,
    parse_run_output,
    compile_cldrive,
)
from cldrive_dataclass import CLdriveResult
from typing import List
def test_cldrive_check_correctness():
    # Test 1: ground truth and generated kernel are the same
    ground_truth_kernel = """
    kernel void my_kernel(global int* a, global int* b) {
    int tid = get_global_id(0);
    a[tid] += 1;
    b[tid] = a[tid] * 2;
}
"""
    generated_kernel = ground_truth_kernel
    assert cldrive_check_correctness(ground_truth_kernel, generated_kernel) == True
    # Test 2: ground truth and generated kernel are different
    generated_kernel = """
    kernel void my_kernel(global int* a, global int* b) {
    int tid = get_global_id(0);
    a[tid] += 2;
    b[tid] = a[tid] * 2;
}
"""
    assert cldrive_check_correctness(ground_truth_kernel, generated_kernel) == False

def test_run_kernels():
    # Run kernels in the list with different seeds
    kernel = """
    kernel void my_kernel(global int* a, global int* b) {
    int tid = get_global_id(0);
    a[tid] += 1;
    b[tid] = a[tid] * 2;
}
"""
    cldrive_output = run_kernel_list([kernel], [1,2,3,4,5])
    assert len(cldrive_output) == 5

def test_run_one_kernel():
    kernel = """
    kernel void my_kernel(global int* a, global int* b) {
    int tid = get_global_id(0);
    a[tid] += 1;
    b[tid] = a[tid] * 2;
}
"""
    compile_cldrive(seed=1)
    cldrive_output_seed1 = run_one_kernel(kernel=kernel, seed=1)
    compile_cldrive(seed=2)
    cldrive_output_seed2 = run_one_kernel(kernel=kernel, seed=2)

    assert cldrive_output_seed1.success == True
    assert len(cldrive_output_seed1.run_output[0]) == 1024
    assert (np.allclose(cldrive_output_seed1.run_output[1], cldrive_output_seed2.run_output[1])) is False
def test_parse_run_output():
    #Test case 1: Output is integer
    output = """
Some text
Output 0: 257918788,-909165268,872171748,1497067262,1553100560
Output 1: 257918788,-909165268,872171748,1497067262,1553100560
Some text
"""
    run_output = parse_run_output(output)
    np.testing.assert_allclose(run_output[0], np.array([257918788,-909165268,872171748,1497067262,1553100560]))
    assert len(run_output) == 2    
    assert len(run_output[0]) == len(run_output[1]) == 5
    #Test case 2: Output is float
    output = """
Some text
Output 0: 257918788.0,-909165268.0,872171748.0,1497067262.0,1553100560.0
Output 1: 257918788.0,-909165268.0,872171748.0,1497067262.0,1553100560.0
Some text
"""
    run_output = parse_run_output(output)
    np.testing.assert_allclose(run_output[0], np.array([257918788,-909165268,872171748,1497067262,1553100560]))
    assert len(run_output) == 2    
    assert len(run_output[0]) == len(run_output[1]) == 5
    #Test case 3: Output is float with scientific notation
    output = """
Some text
Output 0: 2.57918788e+08,-9.09165268e+08,8.72171748e+08,1.49706726e+09,1.55310056e+09
Output 1: 2.57918788e+08,-9.09165268e+08,8.72171748e+08,1.49706726e+09,1.55310056e+09
Some text
"""
    run_output = parse_run_output(output)
    np.testing.assert_allclose(run_output[0], np.array([2.57918788e+08,-9.09165268e+08,8.72171748e+08,1.49706726e+09,1.55310056e+09]))
    assert len(run_output) == 2    
    assert len(run_output[0]) == len(run_output[1]) == 5
    #Test case 4: Output is empty
    output = """
Some text
Output 0:
Output 1:
Some text
"""
    run_output = parse_run_output(output)
    assert run_output[0] == ""
    assert len(run_output) == 2    
   
