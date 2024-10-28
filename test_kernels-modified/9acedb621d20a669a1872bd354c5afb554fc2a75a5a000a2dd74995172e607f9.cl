//{"input_":0,"length_":3,"output_":1,"scratch_":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecsum_contiguous(global const float* input_, global float* output_, local float* scratch_, const int length_) {
  int local_size = get_local_size(0);
  int local_index = get_local_id(0);
  int global_index = get_global_id(0);

  if (global_index < length_) {
    scratch_[hook(2, local_index)] = input_[hook(0, global_index)];
  } else {
    scratch_[hook(2, local_index)] = 0;
  }
  barrier(0x01);

  for (int s = local_size / 2; s > 0; s >>= 1) {
    if (local_index < s) {
      scratch_[hook(2, local_index)] += scratch_[hook(2, local_index + s)];
    }
    barrier(0x01);
  }
  if (local_index == 0) {
    output_[hook(1, get_group_id(0))] = scratch_[hook(2, 0)];
  }
}