//{"in":0,"sum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(global const int* in, global int* sum) {
  size_t i = get_global_id(0);

  atomic_add(sum, in[hook(0, i)]);
}