from pydantic import BaseModel
from typing import List
from numpy import ndarray

class CLdriveResult(BaseModel):
    kernel_src: str
    seed: int
    run_output: List[ndarray]