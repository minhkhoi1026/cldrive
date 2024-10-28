//{"dest":1,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gvn_arbitrary_integers(global int* source, global int* dest) {
  size_t i = get_global_id(0);
  int3 tmp = 0;
  tmp.S2 = source[hook(0, i)];
  vstore3(tmp, 0, dest);
}