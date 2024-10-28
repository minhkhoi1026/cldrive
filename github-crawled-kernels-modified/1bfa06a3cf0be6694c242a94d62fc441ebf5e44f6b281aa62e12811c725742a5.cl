//{"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void squareRoot(global float* values) {
  values[hook(0, get_global_id(0))] = sqrt(values[hook(0, get_global_id(0))]);
}