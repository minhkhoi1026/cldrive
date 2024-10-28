//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global unsigned int* a) {
  const unsigned int aLoad = *a;
  const bool c0 = (aLoad > 42);
  const bool c1 = (aLoad == 42);

  if (c0) {
    *a = 13;
  } else if (c1) {
    *a = 5;
  }
}