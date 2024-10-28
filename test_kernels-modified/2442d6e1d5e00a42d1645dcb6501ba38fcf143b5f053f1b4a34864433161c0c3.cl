//{"coords":0,"elements":1,"group_boundaries":2,"inter_results":6,"result":4,"shared_rows":5,"vector":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_mul(global const uint2* coords, global const float* elements, global const unsigned int* group_boundaries, global const float* vector, global float* result, local unsigned int* shared_rows, local float* inter_results) {
  uint2 tmp;
  float val;
  unsigned int last_index = get_local_size(0) - 1;
  unsigned int group_start = group_boundaries[hook(2, get_group_id(0))];
  unsigned int group_end = group_boundaries[hook(2, get_group_id(0) + 1)];
  unsigned int k_end = (group_end > group_start) ? 1 + (group_end - group_start - 1) / get_local_size(0) : 0;

  unsigned int local_index = 0;

  for (unsigned int k = 0; k < k_end; ++k) {
    local_index = group_start + k * get_local_size(0) + get_local_id(0);

    tmp = (local_index < group_end) ? coords[hook(0, local_index)] : (uint2)0;
    val = (local_index < group_end) ? elements[hook(1, local_index)] * vector[hook(3, tmp.y)] : 0;

    if (get_local_id(0) == 0 && k > 0) {
      if (tmp.x == shared_rows[hook(5, last_index)])
        val += inter_results[hook(6, last_index)];
      else
        result[hook(4, shared_rows[lhook(5, last_index))] = inter_results[hook(6, last_index)];
    }

    barrier(0x01);
    shared_rows[hook(5, get_local_id(0))] = tmp.x;
    inter_results[hook(6, get_local_id(0))] = val;
    float left = 0;
    barrier(0x01);

    for (unsigned int stride = 1; stride < get_local_size(0); stride *= 2) {
      left = (get_local_id(0) >= stride && tmp.x == shared_rows[hook(5, get_local_id(0) - stride)]) ? inter_results[hook(6, get_local_id(0) - stride)] : 0;
      barrier(0x01);
      inter_results[hook(6, get_local_id(0))] += left;
      barrier(0x01);
    }

    if (get_local_id(0) != last_index && shared_rows[hook(5, get_local_id(0))] != shared_rows[hook(5, get_local_id(0) + 1)] && inter_results[hook(6, get_local_id(0))] != 0) {
      result[hook(4, tmp.x)] = inter_results[hook(6, get_local_id(0))];
    }

    barrier(0x01);
  }

  if (get_local_id(0) == last_index && inter_results[hook(6, last_index)] != 0)
    result[hook(4, tmp.x)] = inter_results[hook(6, last_index)];
}