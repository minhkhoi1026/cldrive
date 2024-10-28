//{"data":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int data[4] = {7, 42, 0, -1};

kernel void program_scope_constant_array(global int* output) {
  int i = get_global_id(0);
  output[hook(0, i)] = data[hook(1, i)];
}