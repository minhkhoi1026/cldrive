from cldrive_correctness_checking import cldrive_check_correctness, run_kernels
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

def test_run_kernels(kernel_list: List[str], seed_list:List[int] = [1,2,3,4,5]) -> List[CLdriveResult]:
    # Run kernels in the list with different seeds
    kernel = """
    kernel void my_kernel(global int* a, global int* b) {
    int tid = get_global_id(0);
    a[tid] += 1;
    b[tid] = a[tid] * 2;
}
"""
    cldrive_output = run_kernels([kernel], [1,2,3,4,5])
    assert len(cldrive_output) == 5
    assert cldrive_output[0].run_output != cldrive_output[1].run_output
    assert cldrive_output[1].run_output != cldrive_output[2].run_output
    