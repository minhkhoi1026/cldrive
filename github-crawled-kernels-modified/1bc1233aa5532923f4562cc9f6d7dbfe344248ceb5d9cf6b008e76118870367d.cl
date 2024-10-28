//{"dst":2,"indices":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Reorder_1(global unsigned int* indices, global float* src, global float* dst) {
  const int idx = get_global_id(0);
  dst[hook(2, idx)] = src[hook(1, indices[ihook(0, idx))];
}