//{"input_":0,"length_":3,"output_":1,"scratch_":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecsum_vecvecadd(global const float4* input_, global float* output_, local float4* scratch_, const int length_) {
  int local_index = get_local_id(0);
  int global_index = get_global_id(0);
  int local_size = get_local_size(0);
  int global_size = get_global_size(0);

  int length4 = length_ / 4;

  float4 accumulator = 0;
  for (int offset = global_index; offset < length4; offset += global_size) {
    accumulator += input_[hook(0, offset)];
  }
  scratch_[hook(2, local_index)] = accumulator;
  barrier(0x01);

  for (int s = local_size / 2; s > 0; s >>= 1) {
    if (local_index < s) {
      scratch_[hook(2, local_index)] += scratch_[hook(2, local_index + s)];
    }
    barrier(0x01);
  }
  if (local_index == 0) {
    output_[hook(1, get_group_id(0))] = scratch_[hook(2, 0)].x + scratch_[hook(2, 0)].y + scratch_[hook(2, 0)].z + scratch_[hook(2, 0)].w;
  }
}