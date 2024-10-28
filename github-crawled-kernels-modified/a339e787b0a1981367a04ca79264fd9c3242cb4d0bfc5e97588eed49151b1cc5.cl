//{"dst":0,"height":3,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void default_kernel(global uchar* dst, global const uchar* src, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int idx = y * width + x;

  dst[hook(0, idx)] = src[hook(1, idx)];
}