//{"a":0,"arrayA":3,"arrayB":4,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) krnl_vadd(global int* a, global int* b, global int* c) {
  int arrayA[16];
  int arrayB[16];
readA:
  for (int i = 0; i < 16; i++)
    arrayA[hook(3, i)] = a[hook(0, i)];
readB:
  for (int i = 0; i < 16; i++)
    arrayB[hook(4, i)] = b[hook(1, i)];
vadd_writeC:
  for (int i = 0; i < 16; i++)
    c[hook(2, i)] = arrayA[hook(3, i)] + arrayB[hook(4, i)];
}