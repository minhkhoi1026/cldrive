//{"value":1,"vector":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addToVector(global float* vector, float value) {
  vector[hook(0, get_global_id(0))] += value;
}