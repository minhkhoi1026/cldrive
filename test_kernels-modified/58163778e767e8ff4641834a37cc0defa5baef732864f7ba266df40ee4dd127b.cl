//{"vbo":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill_vbo(global float* vbo) {
  int id = get_global_id(0);
  vbo[hook(0, id)] = (id % 6) / 3 + (id % 2) * (id / 6);
  vbo[hook(0, id)] /= 3;
}