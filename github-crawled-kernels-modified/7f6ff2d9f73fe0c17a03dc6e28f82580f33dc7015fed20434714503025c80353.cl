//{"dst":2,"numElems":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void wgf_reduce(const int numElems, global const int* src, global int* dst) {
  unsigned int global_id = get_global_id(0);

  int sum = 0;
  for (int i = global_id; i < numElems; i += get_global_size(0))
    sum += src[hook(1, i)];

  sum = work_group_reduce_add(sum);

  if (get_local_id(0) == 0)
    dst[hook(2, get_group_id(0))] = sum;
}