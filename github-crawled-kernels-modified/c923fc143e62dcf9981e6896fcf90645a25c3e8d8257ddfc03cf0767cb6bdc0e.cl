//{"in":0,"out":1,"slope":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(256, 1, 1))) __attribute__((reqd_work_group_size(256, 1, 1))) kernel void ReluOnly(const global float* restrict in, global float* restrict out, float slope) {
  out[hook(1, get_global_id(0))] = in[hook(0, get_global_id(0))] * (in[hook(0, get_global_id(0))] > 0.0f ? 1.0f : slope);
}