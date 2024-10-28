//{"table":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pad_methode_1(global int* table, int width) {
  const int j = get_global_id(0) + 1;
  const int i = get_global_id(1) + 1;
  if (table[hook(0, i * width + j)] == table[hook(0, (i - 1) * width + j)]) {
    table[hook(0, i * width + j)] = 1;
  } else if (table[hook(0, i * width + j)] == table[hook(0, i * width + j - 1)]) {
    table[hook(0, i * width + j)] = 2;
  }
}