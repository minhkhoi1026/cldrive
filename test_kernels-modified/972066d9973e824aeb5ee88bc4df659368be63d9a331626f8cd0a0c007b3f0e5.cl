//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyBuffer(global unsigned int* src, global unsigned int* dst) {
  int id = (int)get_global_id(0);
  dst[hook(1, id)] = lgamma((float)src[hook(0, id)]);
  dst[hook(1, id)] = src[hook(0, id)];
}