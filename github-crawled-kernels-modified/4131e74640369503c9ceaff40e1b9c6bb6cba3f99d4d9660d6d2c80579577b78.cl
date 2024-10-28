//{"(*a).a":2,"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct Thing {
  float a[128];
};

float bar(global struct Thing* a) {
  return (*a).a[hook(2, 5)];
}

kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float* a, global struct Thing* b) {
  *a = bar(b);
}