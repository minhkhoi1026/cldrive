//{"dev_values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pointless(global unsigned int* dev_values) {
  const unsigned int i = get_global_id(0);
  dev_values[hook(0, i)] += 1;
}