//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_vector(global char* in, global char* out) {
  int iNum = get_global_id(0);
  out[hook(1, iNum)] = in[hook(0, iNum)] + 1;
}