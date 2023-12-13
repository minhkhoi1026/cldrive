from typing import List
from cldrive_dataclass import CLdriveResult

def cldrive_check_correctness(ground_truth_kernel: str, generated_kernel: str) -> bool:
    """Check correctness of CLDRIVE."""
    pass
def run_kernels(kernel_list: List[str], seed_list:List[int] = [1,2,3,4,5]) -> List[CLdriveResult]:
    for seed in seed_list:
        for kernel in kernel_list:
            # Run kernel with seed
            # Save output to CLdriveResult
            pass
def compile_cldrive(seed: int) -> None:
    """Compile CLDRIVE with the provided seed."""
    pass
