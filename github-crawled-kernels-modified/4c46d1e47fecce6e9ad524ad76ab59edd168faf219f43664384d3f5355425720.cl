//{"in":0,"in_width":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transfer(global float4* in, int in_width, global float4* out) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int width = get_global_size(0);
  out[hook(2, gidy * width + gidx)] = in[hook(0, gidy * in_width + gidx)];
}