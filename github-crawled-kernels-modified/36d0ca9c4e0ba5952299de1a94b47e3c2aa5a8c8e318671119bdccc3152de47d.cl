//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void map(global float* data) {
  int id = get_global_id(0);
  float square = data[hook(0, id)] * data[hook(0, id)];
  data[hook(0, id)] = square;
}