// Copyright (c) 2016, 2017, 2018, 2019 Chris Cummins.
// This file is part of cldrive.
//
// cldrive is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// cldrive is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with cldrive.  If not, see <https://www.gnu.org/licenses/>.
#include "gpu/cldrive/opencl_util.h"

namespace gpu {
namespace cldrive {
namespace util {

string GetOpenClKernelName(const cl::Kernel& kernel) {
  // Deliberately use the long-form C API.
  // While the C++ API provides a kernel.getInfo<>() method, I've received a
  // report that it doesn't work on at least one platform, and the
  // implementation has other defects when handling char* parameters, e.g.:
  // https://github.com/KhronosGroup/OpenCL-CLHPP/issues/8

  // Get the size of the name.
  size_t name_size;
  CHECK(clGetKernelInfo(
      kernel(), CL_KERNEL_FUNCTION_NAME, /*param_value_size=*/0,
      /*param_value=*/nullptr, &name_size) == CL_SUCCESS);
  CHECK(name_size) << "Size of CL_KERNEL_FUNCTION_NAME is zero";

  // Allocate a temporary buffer and read the name to it.
  char *chars = new char[name_size];
  CHECK(clGetKernelInfo(
      kernel(), CL_KERNEL_FUNCTION_NAME, name_size, chars,
      /*param_value_size_ret=*/nullptr) == CL_SUCCESS);

  // Construct a string from the buffer.
  string name(chars);
  // name_size includes trailing '\0', name.size() does not.
  CHECK(name.size() == name_size - 1);

  // Free the buffer.
  delete[] chars;

  return name;
}

string GetKernelArgTypeName(const cl::Kernel& kernel, size_t arg_index) {
  // Deliberately use the long-form C API.
  // While the C++ API provides a kernel.getInfo<>() method, I've received a
  // report that it doesn't work on at least one platform, and the
  // implementation has other defects when handling char* parameters, e.g.:
  // https://github.com/KhronosGroup/OpenCL-CLHPP/issues/8

  // Get the size of the name.
  size_t name_size;
  CHECK(clGetKernelArgInfo(
      kernel(), arg_index, CL_KERNEL_ARG_TYPE_NAME, /*param_value_size=*/0,
      /*param_value=*/nullptr, &name_size) == CL_SUCCESS);
  CHECK(name_size) << "Size of CL_KERNEL_ARG_TYPE_NAME is zero";

  // Allocate a temporary buffer and read the name to it.
  char *chars = new char[name_size];
  CHECK(clGetKernelArgInfo(
      kernel(), arg_index, CL_KERNEL_ARG_TYPE_NAME, name_size, chars,
      /*param_value_size_ret=*/nullptr) == CL_SUCCESS);

  // Construct a string from the buffer.
  string name(chars);
  // name_size includes trailing '\0', name.size() does not.
  CHECK(name.size() == name_size - 1);

  // Free the buffer.
  delete[] chars;

  return name;
}

}  // namespace util
}  // namespace cldrive
}  // namespace gpu
