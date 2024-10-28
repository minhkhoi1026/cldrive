//{"base_index":4,"group_index":3,"input_data":1,"n":5,"output_data":0,"partial_sums":6,"shared_data":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uint4 GetAddressMapping(int index) {
  const unsigned int local_id = get_local_id(0);
  const unsigned int group_id = get_global_id(0) / get_local_size(0);
  const unsigned int group_size = get_local_size(0);

  uint2 global_index;
  global_index.x = index + local_id;
  global_index.y = global_index.x + group_size;

  uint2 local_index;
  local_index.x = local_id;
  local_index.y = local_id + group_size;

  return (uint4)(global_index.x, global_index.y, local_index.x, local_index.y);
}

void LoadLocalFromGlobal(local float* shared_data, global const float* input_data, const uint4 address_pair, const unsigned int n) {
  const unsigned int global_index_a = address_pair.x;
  const unsigned int global_index_b = address_pair.y;

  const unsigned int local_index_a = address_pair.z;
  const unsigned int local_index_b = address_pair.w;

  const unsigned int bank_offset_a = ((local_index_a) >> (4));
  const unsigned int bank_offset_b = ((local_index_b) >> (4));

  shared_data[hook(2, local_index_a + bank_offset_a)] = input_data[hook(1, global_index_a)];
  shared_data[hook(2, local_index_b + bank_offset_b)] = input_data[hook(1, global_index_b)];
}

void LoadLocalFromGlobalNonPowerOfTwo(local float* shared_data, global const float* input_data, const uint4 address_pair, const unsigned int n) {
  const unsigned int global_index_a = address_pair.x;
  const unsigned int global_index_b = address_pair.y;

  const unsigned int local_index_a = address_pair.z;
  const unsigned int local_index_b = address_pair.w;

  const unsigned int bank_offset_a = ((local_index_a) >> (4));
  const unsigned int bank_offset_b = ((local_index_b) >> (4));

  shared_data[hook(2, local_index_a + bank_offset_a)] = input_data[hook(1, global_index_a)];
  shared_data[hook(2, local_index_b + bank_offset_b)] = (local_index_b < n) ? input_data[hook(1, global_index_b)] : 0;

  barrier(0x01);
}

void StoreLocalToGlobal(global float* output_data, local const float* shared_data, const uint4 address_pair, const unsigned int n) {
  barrier(0x01);

  const unsigned int global_index_a = address_pair.x;
  const unsigned int global_index_b = address_pair.y;

  const unsigned int local_index_a = address_pair.z;
  const unsigned int local_index_b = address_pair.w;

  const unsigned int bank_offset_a = ((local_index_a) >> (4));
  const unsigned int bank_offset_b = ((local_index_b) >> (4));

  output_data[hook(0, global_index_a)] = shared_data[hook(2, local_index_a + bank_offset_a)];
  output_data[hook(0, global_index_b)] = shared_data[hook(2, local_index_b + bank_offset_b)];
}

void StoreLocalToGlobalNonPowerOfTwo(global float* output_data, local const float* shared_data, const uint4 address_pair, const unsigned int n) {
  barrier(0x01);

  const unsigned int global_index_a = address_pair.x;
  const unsigned int global_index_b = address_pair.y;

  const unsigned int local_index_a = address_pair.z;
  const unsigned int local_index_b = address_pair.w;

  const unsigned int bank_offset_a = ((local_index_a) >> (4));
  const unsigned int bank_offset_b = ((local_index_b) >> (4));

  output_data[hook(0, global_index_a)] = shared_data[hook(2, local_index_a + bank_offset_a)];
  if (local_index_b < n)
    output_data[hook(0, global_index_b)] = shared_data[hook(2, local_index_b + bank_offset_b)];
}

void ClearLastElement(local float* shared_data, int group_index) {
  const unsigned int local_id = get_local_id(0);
  const unsigned int group_id = get_global_id(0) / get_local_size(0);
  const unsigned int group_size = get_local_size(0);

  if (local_id == 0) {
    int index = (group_size << 1) - 1;
    index += ((index) >> (4));
    shared_data[hook(2, index)] = 0;
  }
}

void ClearLastElementStoreSum(local float* shared_data, global float* partial_sums, int group_index) {
  const unsigned int group_id = get_global_id(0) / get_local_size(0);
  const unsigned int group_size = get_local_size(0);
  const unsigned int local_id = get_local_id(0);

  if (local_id == 0) {
    int index = (group_size << 1) - 1;
    index += ((index) >> (4));
    partial_sums[hook(6, group_index)] = shared_data[hook(2, index)];
    shared_data[hook(2, index)] = 0;
  }
}

unsigned int BuildPartialSum(local float* shared_data) {
  const unsigned int local_id = get_local_id(0);
  const unsigned int group_size = get_local_size(0);
  const unsigned int two = 2;
  unsigned int stride = 1;

  for (unsigned int j = group_size; j > 0; j >>= 1) {
    barrier(0x01);

    if (local_id < j) {
      int i = mul24(mul24(two, stride), local_id);

      unsigned int local_index_a = i + stride - 1;
      unsigned int local_index_b = local_index_a + stride;

      local_index_a += ((local_index_a) >> (4));
      local_index_b += ((local_index_b) >> (4));

      shared_data[hook(2, local_index_b)] += shared_data[hook(2, local_index_a)];
    }

    stride *= two;
  }

  return stride;
}

void ScanRootToLeaves(local float* shared_data, unsigned int stride) {
  const unsigned int local_id = get_local_id(0);
  const unsigned int group_id = get_global_id(0) / get_local_size(0);
  const unsigned int group_size = get_local_size(0);
  const unsigned int two = 2;

  for (unsigned int j = 1; j <= group_size; j *= two) {
    stride >>= 1;

    barrier(0x01);

    if (local_id < j) {
      int i = mul24(mul24(two, stride), local_id);

      unsigned int local_index_a = i + stride - 1;
      unsigned int local_index_b = local_index_a + stride;

      local_index_a += ((local_index_a) >> (4));
      local_index_b += ((local_index_b) >> (4));

      float t = shared_data[hook(2, local_index_a)];
      shared_data[hook(2, local_index_a)] = shared_data[hook(2, local_index_b)];
      shared_data[hook(2, local_index_b)] += t;
    }
  }
}

void PreScanGroup(local float* shared_data, int group_index) {
  const unsigned int group_id = get_global_id(0) / get_local_size(0);

  int stride = BuildPartialSum(shared_data);
  ClearLastElement(shared_data, (group_index == 0) ? group_id : group_index);
  ScanRootToLeaves(shared_data, stride);
}

void PreScanGroupStoreSum(global float* partial_sums, local float* shared_data, int group_index) {
  const unsigned int group_id = get_global_id(0) / get_local_size(0);

  int stride = BuildPartialSum(shared_data);
  ClearLastElementStoreSum(shared_data, partial_sums, (group_index == 0) ? group_id : group_index);
  ScanRootToLeaves(shared_data, stride);
}

kernel void PreScanNonPowerOfTwoKernel(global float* output_data, global const float* input_data, local float* shared_data, const unsigned int group_index, const unsigned int base_index, const unsigned int n) {
  const unsigned int local_id = get_local_id(0);
  const unsigned int group_id = get_global_id(0) / get_local_size(0);
  const unsigned int group_size = get_local_size(0);

  unsigned int local_index = (base_index == 0) ? mul24(group_id, (group_size << 1)) : base_index;
  uint4 address_pair = GetAddressMapping(local_index);

  LoadLocalFromGlobalNonPowerOfTwo(shared_data, input_data, address_pair, n);
  PreScanGroup(shared_data, group_index);
  StoreLocalToGlobalNonPowerOfTwo(output_data, shared_data, address_pair, n);
}