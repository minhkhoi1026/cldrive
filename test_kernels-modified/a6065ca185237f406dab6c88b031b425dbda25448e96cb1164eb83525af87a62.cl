//{"array":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void generatefloat(global float* array) {
  int i = get_global_id(0);
  array[hook(0, i)] = (float)i;
}