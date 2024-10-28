//{"count":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void linear(global int* output, const unsigned int count) {
  size_t i = get_global_id(0);
  output[hook(0, i)] = i;
}