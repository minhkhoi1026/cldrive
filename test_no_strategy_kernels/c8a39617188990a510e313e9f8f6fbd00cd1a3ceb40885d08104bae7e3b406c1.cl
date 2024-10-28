//{"dim":2,"input_itemsets":1,"penalty":3,"reference":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int maximum(int a, int b, int c) {
  int k;
  if (a <= b)
    k = b;
  else
    k = a;

  if (k <= c)
    return (c);
  else
    return (k);
}

__attribute__((max_global_work_dim(0))) kernel void nw_kernel1(global int* restrict reference, global int* restrict input_itemsets, int dim, int penalty) {
  for (int j = 1; j < dim - 1; ++j) {
    int backup = input_itemsets[hook(1, j * dim)];

    for (int i = 1; i < dim - 1; ++i) {
      int index = j * dim + i;
      input_itemsets[hook(1, index)] = backup = maximum(input_itemsets[hook(1, index - 1 - dim)] + reference[hook(0, index)], backup - penalty, input_itemsets[hook(1, index - dim)] - penalty);
    }
  }
}