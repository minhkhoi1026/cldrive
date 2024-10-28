//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyOver(global float* src, global float* dst) {
  dst[hook(1, get_global_id(0))] = src[hook(0, get_global_id(0))];
}