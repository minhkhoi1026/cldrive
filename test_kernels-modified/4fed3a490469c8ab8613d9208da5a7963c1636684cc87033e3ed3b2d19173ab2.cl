//{"vertices":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zoom(global float* vertices) {
  unsigned int id = get_global_id(0);
  vertices[hook(0, id)] *= 1.01;
}