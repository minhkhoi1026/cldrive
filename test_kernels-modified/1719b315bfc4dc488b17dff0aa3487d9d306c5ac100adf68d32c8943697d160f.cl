//{"a":0,"answer":2,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global float* a, global float* b, global float* answer) {
  int gid = get_global_id(0);
  answer[hook(2, gid)] = a[hook(0, gid)] + b[hook(1, gid)];
}