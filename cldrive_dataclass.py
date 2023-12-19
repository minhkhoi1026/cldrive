from pydantic import BaseModel, ConfigDict
from typing import List, Union, Optional
from numpy import ndarray

class CLdriveResult(BaseModel):
    kernel_id: str
    kernel_src: str
    success: bool
    error: Optional[str] = None
    seed: int
    run_output: Optional[str] = None
    model_config = ConfigDict(arbitrary_types_allowed=True)