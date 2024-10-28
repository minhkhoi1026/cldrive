//{"output":1,"vector":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_argument(int4 vector, global int4* output) {
  *output = vector + 42;
}