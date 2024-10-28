//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomTest5(global int* out) {
  int t1 = atomic_inc(&out[hook(0, 0)]);
}