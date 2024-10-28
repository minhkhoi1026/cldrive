//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global int* a, global int* b, global int* c, global int* result) {
  result[hook(3, 0)] = mad24(a[hook(0, 0)], b[hook(1, 0)], c[hook(2, 0)]);
  result[hook(3, 1)] = mul24(a[hook(0, 1)], b[hook(1, 1)]);
  result[hook(3, 2)] = clz(a[hook(0, 2)]);
  result[hook(3, 3)] = clamp(a[hook(0, 3)], b[hook(1, 3)], c[hook(2, 3)]);
  result[hook(3, 4)] = mad_hi(a[hook(0, 4)], b[hook(1, 4)], c[hook(2, 4)]);
  result[hook(3, 5)] = mad_sat(a[hook(0, 5)], b[hook(1, 5)], c[hook(2, 5)]);
  result[hook(3, 6)] = max(a[hook(0, 6)], b[hook(1, 6)]);
  result[hook(3, 7)] = min(a[hook(0, 7)], b[hook(1, 7)]);
  result[hook(3, 8)] = mul_hi(a[hook(0, 8)], b[hook(1, 8)]);
  result[hook(3, 9)] = rotate(a[hook(0, 9)], b[hook(1, 9)]);
  result[hook(3, 10)] = sub_sat(a[hook(0, 10)], b[hook(1, 10)]);
  result[hook(3, 11)] = abs(a[hook(0, 11)]);
  result[hook(3, 12)] = abs_diff(a[hook(0, 12)], b[hook(1, 12)]);
  result[hook(3, 13)] = add_sat(a[hook(0, 13)], b[hook(1, 13)]);
  result[hook(3, 14)] = hadd(a[hook(0, 14)], b[hook(1, 14)]);
  result[hook(3, 15)] = rhadd(a[hook(0, 15)], b[hook(1, 15)]);
}