from pydantic import BaseModel, ConfigDict
from typing import List, Union
from numpy import ndarray

class CLdriveResult(BaseModel):
    kernel_src: str
    success: bool
    seed: int
    run_output: List[Union[ndarray, str]]
    model_config = ConfigDict(arbitrary_types_allowed=True)