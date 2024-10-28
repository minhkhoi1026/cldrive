//{"dest":0,"source":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_memcpy_gather(global float* dest, global float* source) {
  int x = get_global_id(0);
  int size = get_global_size(0);
  dest[hook(0, x)] = source[hook(1, x)];
  dest[hook(0, x + size)] = source[hook(1, x + size)];
  dest[hook(0, x + size * 2)] = source[hook(1, x + size * 2)];
  dest[hook(0, x + size * 3)] = source[hook(1, x + size * 3)];
  dest[hook(0, x + size * 4)] = source[hook(1, x + size * 4)];
  dest[hook(0, x + size * 5)] = source[hook(1, x + size * 5)];
  dest[hook(0, x + size * 6)] = source[hook(1, x + size * 6)];
  dest[hook(0, x + size * 7)] = source[hook(1, x + size * 7)];
  dest[hook(0, x + size * 8)] = source[hook(1, x + size * 8)];
  dest[hook(0, x + size * 9)] = source[hook(1, x + size * 9)];
  dest[hook(0, x + size * 10)] = source[hook(1, x + size * 10)];
  dest[hook(0, x + size * 11)] = source[hook(1, x + size * 11)];
  dest[hook(0, x + size * 12)] = source[hook(1, x + size * 12)];
  dest[hook(0, x + size * 13)] = source[hook(1, x + size * 13)];
  dest[hook(0, x + size * 14)] = source[hook(1, x + size * 14)];
  dest[hook(0, x + size * 15)] = source[hook(1, x + size * 15)];
}