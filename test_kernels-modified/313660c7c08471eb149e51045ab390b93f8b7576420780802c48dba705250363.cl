//{"table":1,"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(int val) {
  int table[10] = {5, 5, 5, 5, 5, 5, 5, 5, 5, 5};
  table[hook(1, 1)] = val;
  long table_address_as_int = (long)table;

  table_address_as_int += 200 * sizeof(int);
  int* pointer = (int*)table_address_as_int;
  printf("%i", *pointer);
}