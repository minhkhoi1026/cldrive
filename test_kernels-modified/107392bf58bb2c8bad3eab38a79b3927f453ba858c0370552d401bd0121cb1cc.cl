//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void write_vector_write_only_fp(global int4* output) {
  int i = get_global_id(0);
  output[hook(0, i)].x = 42;
}