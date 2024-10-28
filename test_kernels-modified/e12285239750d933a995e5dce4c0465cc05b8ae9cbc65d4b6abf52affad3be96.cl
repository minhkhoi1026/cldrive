//{"cache":4,"gridA":0,"gridB":1,"num_elements":3,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dotProduct(global const float* gridA, global const float* gridB, global float* result, int const num_elements, local float* cache) {
  const unsigned int local_id = get_local_id(0);
  const unsigned int global_id = get_global_id(0);
  const unsigned int group_id = get_group_id(0);
  const unsigned int local_size = get_local_size(0);

  cache[hook(4, local_id)] = (global_id < num_elements) ? (gridA[hook(0, global_id)] * gridB[hook(1, global_id)]) : 0.0f;
  barrier(0x01);

  for (unsigned int s = local_size >> 1; s > 0; s >>= 1) {
    if (local_id < s) {
      cache[hook(4, local_id)] += cache[hook(4, local_id + s)];
    }
    barrier(0x01);
  }

  if (local_id == 0)
    result[hook(2, group_id)] = cache[hook(4, 0)];
}