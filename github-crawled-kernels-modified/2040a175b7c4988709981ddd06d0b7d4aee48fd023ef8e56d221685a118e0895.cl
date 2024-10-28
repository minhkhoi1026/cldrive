//{"out":3,"val":0,"val2":1,"val3":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void test_relational(const float16 val, const float16 val2, const int16 val3, global int16* out) {
  int i = 0;
  out[hook(3, i++)] = isequal(val, val2);
  out[hook(3, i++)] = isnotequal(val, val2);
  out[hook(3, i++)] = isgreater(val, val2);
  out[hook(3, i++)] = isgreaterequal(val, val2);
  out[hook(3, i++)] = isless(val, val2);
  out[hook(3, i++)] = islessgreater(val, val2);
  out[hook(3, i++)] = isfinite(val);
  out[hook(3, i++)] = isinf(val);
  out[hook(3, i++)] = isnan(val);
  out[hook(3, i++)] = isnormal(val);
  out[hook(3, i++)] = isordered(val, val2);
  out[hook(3, i++)] = isunordered(val, val2);
  out[hook(3, i++)] = signbit(val);
  out[hook(3, i++)] = any(val3);
  out[hook(3, i++)] = all(val3);
  out[hook(3, i++)] = convert_int16(bitselect(val, val2, val));
  out[hook(3, i++)] = convert_int16(select(val, val2, convert_uint16(val3)));
}