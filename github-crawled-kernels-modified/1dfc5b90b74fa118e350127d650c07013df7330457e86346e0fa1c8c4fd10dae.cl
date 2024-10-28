//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float* a) {
  const float aLoad = *a;

  const bool c = (aLoad <= 42.0f);

  const float cAs = c;

  *a = cAs;
}