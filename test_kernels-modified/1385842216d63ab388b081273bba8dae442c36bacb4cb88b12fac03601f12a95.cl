//{"dest":1,"src":0,"tmp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sync(global float* src, global float* dest, local float* tmp) {
  int tid = get_local_id(0);
  int i = get_global_id(0);

  tmp[hook(2, tid)] = src[hook(0, i)];

  barrier(0x01);

  for (int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (tid < s) {
      tmp[hook(2, tid)] += tmp[hook(2, tid + s)];
    }
    barrier(0x01);
  }

  if (tid == 0)
    dest[hook(1, get_group_id(0))] = tmp[hook(2, 0)];
}