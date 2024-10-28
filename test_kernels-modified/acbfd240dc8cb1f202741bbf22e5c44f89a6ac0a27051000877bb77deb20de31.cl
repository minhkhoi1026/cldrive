//{"out":2,"val":0,"val2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void test_common(const float val, const float val2, global float* out) {
  int i = 0;
  out[hook(2, i++)] = clamp(val, 0.0f, val2);
  out[hook(2, i++)] = degrees(val);
  out[hook(2, i++)] = max(val, val2);
  out[hook(2, i++)] = min(val, val2);
  out[hook(2, i++)] = mix(val, val2, 0.5f);
  out[hook(2, i++)] = radians(val);
  out[hook(2, i++)] = step(val, val2);
  out[hook(2, i++)] = smoothstep(val, 0.0f, val2);
  out[hook(2, i++)] = sign(val);
}