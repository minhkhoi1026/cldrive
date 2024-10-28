//{"array":0,"singlevalue":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simplekernel(global int* array, const int singlevalue) {
  int i = get_global_id(0);
  array[hook(0, i)] = array[hook(0, i)] * array[hook(0, i)];
}