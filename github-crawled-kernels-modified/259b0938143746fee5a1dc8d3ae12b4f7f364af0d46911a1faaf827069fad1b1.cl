//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const constant float filter_flag = 0.111111f;
kernel void bench_copy_buffer_uint(global uint4* src, global uint4* dst) {
  int x = (int)get_global_id(0);
  int y = (int)get_global_id(1);
  int x_sz = (int)get_global_size(0);
  dst[hook(1, y * x_sz + x)] = src[hook(0, y * x_sz + x)];
}