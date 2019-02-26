// This file performs the translation from OpenClType enum value to templated
// classes.
//
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

#pragma once

#include "gpu/cldrive/kernel_arg_value.h"
#include "gpu/cldrive/opencl_type.h"

#include "third_party/opencl/cl.hpp"

#include <cstdlib>

namespace gpu {
namespace cldrive {
namespace util {

<<<<<<< HEAD:gpu/cldrive/opencl_type_util.h
std::unique_ptr<KernelArgValue> CreateGlobalMemoryArgValue(
    const OpenClType& type, const cl::Context& context, size_t size,
    const int& value, bool rand_values);

std::unique_ptr<KernelArgValue> CreateLocalMemoryArgValue(
    const OpenClType& type, size_t size);

std::unique_ptr<KernelArgValue> CreateScalarArgValue(const OpenClType& type,
                                                     const int& value);

<<<<<<< HEAD:gpu/cldrive/opencl_type_util.h
<<<<<<< HEAD:gpu/cldrive/opencl_type_util.h
}  // namespace util
=======
>>>>>>> ac755253f... Remove commented out code.:gpu/cldrive/array_kernel_arg_value.cc
=======
namespace {

// TODO(cldrive): Work in progress!

template <typename T>
bool Vec2Equality(const T& lhs, const T& rhs) {
  return true;
  // TODO: return (l[0] == r[0]) && (l[1] == r[1]);
}

}  // anonymous namespace

template <>
/*virtual*/ string ArrayKernelArgValue<cl_char2>::ToString() const {
  string s = "";
  return s;
}

template <>
/*virtual*/ bool ArrayKernelArgValue<cl_char2>::ElementEquality(
    const cl_char2& lhs, const cl_char2& rhs) const {
  return Vec2Equality(lhs, rhs);
}
=======
namespace {}
>>>>>>> 36b52bcfa... Work in progress cldrive args.:gpu/cldrive/array_kernel_arg_value.cc

>>>>>>> 8b16e8e86... Work in progress on cldrive vector args.:gpu/cldrive/array_kernel_arg_value.cc
}  // namespace cldrive
}  // namespace gpu
