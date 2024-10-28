//{"nx":2,"ny":3,"t":0,"t_next":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init(global float* t, global float* t_next, unsigned int nx, unsigned int ny) {
  size_t i = get_global_id(0);
  size_t j = get_global_id(1);

  if (i < nx - 1 && j < ny - 1) {
    size_t k_ij = i * ny + j;

    t[hook(0, k_ij)] = 0;
    t_next[hook(1, k_ij)] = 0;
  }
}