//{"out":2,"val":0,"val2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void test_integer(const int val, const int val2, global int* out) {
  int i = 0;
  out[hook(2, i++)] = abs(val);
  out[hook(2, i++)] = abs_diff(val, val2);
  out[hook(2, i++)] = add_sat(val, val2);
  out[hook(2, i++)] = hadd(val, val2);
  out[hook(2, i++)] = rhadd(val, val2);
  out[hook(2, i++)] = clamp(val, 0, val2);
  out[hook(2, i++)] = clz(val);
  out[hook(2, i++)] = mad_hi(val, val2, val2);
  out[hook(2, i++)] = mad_sat(val, val2, val2);
  out[hook(2, i++)] = max(val, val2);
  out[hook(2, i++)] = min(val, val2);
  out[hook(2, i++)] = mul_hi(val, val2);
  out[hook(2, i++)] = rotate(val, val2);
  out[hook(2, i++)] = sub_sat(val, val2);
  out[hook(2, i++)] = upsample((short)val, (ushort)val2);
  out[hook(2, i++)] = mad24(val, val2, val2);
  out[hook(2, i++)] = mul24(val, val2);
}