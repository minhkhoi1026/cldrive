//{"d_out":0,"first":1,"second":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_float2_kernel(global float2* d_out, const float first, const float second) {
  const unsigned int gidx = get_global_id(0);
  d_out[hook(0, gidx)] = (float2)(first, second);
}