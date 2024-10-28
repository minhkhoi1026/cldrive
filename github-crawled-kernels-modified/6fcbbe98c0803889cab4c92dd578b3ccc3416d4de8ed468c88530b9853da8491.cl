//{"num_ints":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void profile_items(global int4* x, int num_ints) {
  int num_vectors = num_ints / (4 * get_global_size(0));

  x += get_global_id(0) * num_vectors;
  for (int i = 0; i < num_vectors; i++) {
    x[hook(0, i)] += 1;
    x[hook(0, i)] *= 2;
    x[hook(0, i)] /= 3;
  }
}