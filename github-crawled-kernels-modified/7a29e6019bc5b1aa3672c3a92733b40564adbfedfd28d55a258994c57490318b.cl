//{"array":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square_array(global float* array) {
  int id = get_global_id(0);
  array[hook(0, id)] = array[hook(0, id)] * array[hook(0, id)];
}