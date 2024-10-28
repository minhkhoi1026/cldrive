//{"dest":0,"source":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_memcpy(global float4* dest, global float4* source) {
  int x = get_global_id(0);
  int size = get_global_size(0);
  dest[hook(0, x)] = source[hook(1, x)];
  dest[hook(0, x + size)] = source[hook(1, x + size)];
  dest[hook(0, x + size * 2)] = source[hook(1, x + size * 2)];
  dest[hook(0, x + size * 3)] = source[hook(1, x + size * 3)];
}