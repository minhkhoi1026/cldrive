//{"output":1,"value":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void broadcast(global int* value, global int* output) {
  int i = get_global_id(0);
  output[hook(1, i)] = value[hook(0, 0)];
}