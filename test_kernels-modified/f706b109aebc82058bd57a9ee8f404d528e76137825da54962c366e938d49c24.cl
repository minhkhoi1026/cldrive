//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global int4* a, global int4* b, global int4* c, global int4* result) {
  result[hook(3, 0)] = a[hook(0, 0)] * b[hook(1, 0)] + c[hook(2, 0)] - a[hook(0, 0)];
  result[hook(3, 1)] = mad_hi(a[hook(0, 1)], b[hook(1, 1)], c[hook(2, 1)]);
  result[hook(3, 2)] = mad_sat(a[hook(0, 2)], b[hook(1, 2)], c[hook(2, 2)]);
  result[hook(3, 3)] = mad24(a[hook(0, 3)], b[hook(1, 3)], c[hook(2, 3)]);
}