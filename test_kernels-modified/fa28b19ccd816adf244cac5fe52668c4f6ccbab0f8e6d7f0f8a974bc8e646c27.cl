//{"bitsum":1,"pivot":2,"xs":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter(global float* xs, global int* bitsum, float pivot) {
  int i = (get_global_id(0) << 1);
  int j = i + 1;
  int i_bit = xs[hook(0, i)] <= pivot ? 1 : 0;
  int j_bit = xs[hook(0, j)] <= pivot ? 1 : 0;

  bitsum[hook(1, i)] = i_bit;
  bitsum[hook(1, j)] = i_bit + j_bit;
}