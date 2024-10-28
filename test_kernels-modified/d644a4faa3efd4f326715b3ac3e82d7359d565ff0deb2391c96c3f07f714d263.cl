//{"table":1,"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(int val) {
  int table[10];
  table[hook(1, 1)] = val;
  ulong table_address_as_int = (ulong)table;
  table_address_as_int += sizeof(int);
  int* pointer = (int*)table_address_as_int;
  printf("%i", *pointer);
}