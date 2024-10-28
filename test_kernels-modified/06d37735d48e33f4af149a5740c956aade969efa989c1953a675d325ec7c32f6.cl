//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copyBuffer(global float* src, global float* dst) {
  const int index = get_global_id(0);
  dst[hook(1, index)] = src[hook(0, index)];
}