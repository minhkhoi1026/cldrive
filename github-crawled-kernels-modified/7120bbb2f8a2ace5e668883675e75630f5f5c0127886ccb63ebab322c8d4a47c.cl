//{"out":2,"val":0,"val2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void test_geometric(const float4 val, const float4 val2, global float4* out) {
  int i = 0;
  out[hook(2, i++)] = cross(val, val2);
  out[hook(2, i++)].x = dot(val, val2);
  out[hook(2, i++)].x = distance(val, val2);
  out[hook(2, i++)].x = length(val);
  out[hook(2, i++)] = normalize(val);
}