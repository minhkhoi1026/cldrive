//{"result":1,"size":2,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vmax(global float* vec1, global float* result, unsigned int size) {
  for (unsigned int stride = get_global_size(0) / 2; stride > 0; stride /= 2) {
    if (get_global_id(0) < stride)
      vec1[hook(0, get_global_id(0))] = fmax(vec1[hook(0, get_global_id(0) + stride)], vec1[hook(0, get_global_id(0))]);
    barrier(0x02);
  }

  if (get_global_id(0) == 0)
    *result = vec1[hook(0, 0)];
}