//{"in":0,"offset":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_copy(global int* in, global int* out, int offset) {
  int id = get_global_id(0);
  out[hook(1, id + offset)] = in[hook(0, id + offset)];
}