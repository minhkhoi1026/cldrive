//{"c":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(global float* c) {
  int gid = get_global_id(0);
  c[hook(0, gid)] = 1.f;
}