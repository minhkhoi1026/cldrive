//{"chids":0,"heads":3,"input":1,"len":4,"tmp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void column_prepare(global const unsigned int* restrict chids, global const unsigned int* restrict input, global unsigned int* restrict tmp, global unsigned int* restrict heads, unsigned int len) {
  const unsigned int n_half = get_global_size(0);
  const unsigned int ai = get_global_id(0);
  const unsigned int bi = get_global_id(0) + n_half;
  if (ai < len) {
    tmp[hook(2, ai)] = 1 + (chids[hook(0, ai)] != 0);
    heads[hook(3, ai)] = (ai == 0) || (input[hook(1, ai)] != input[hook(1, ai - 1)]);
  }
  if (bi < len) {
    tmp[hook(2, bi)] = 1 + (chids[hook(0, bi)] != 0);
    heads[hook(3, bi)] = (input[hook(1, bi)] != input[hook(1, bi - 1)]);
  }
}