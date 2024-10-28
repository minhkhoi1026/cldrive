//{"a":0,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void inverse(global float* a, global float* result) {
  int gid = get_global_id(0);
  result[hook(1, gid)] = 1.0f / a[hook(0, gid)];
}