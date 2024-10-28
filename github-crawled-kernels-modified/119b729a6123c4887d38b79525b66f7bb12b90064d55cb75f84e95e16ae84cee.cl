//{"result":1,"size":2,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sqrt_sum(global float* vec1, global float* result, unsigned int size) {
  for (unsigned int stride = get_global_size(0) / 2; stride > 0; stride /= 2) {
    if (get_global_id(0) < stride)
      vec1[hook(0, get_global_id(0))] += vec1[hook(0, get_global_id(0) + stride)];
    barrier(0x02);
  }

  if (get_global_id(0) == 0)
    *result = sqrt(vec1[hook(0, 0)]);
}