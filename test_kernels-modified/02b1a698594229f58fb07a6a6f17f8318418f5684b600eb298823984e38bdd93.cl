//{"out_max":1,"out_min":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_stretch(global float4* out_min, global float4* out_max) {
  int gid = get_global_id(0);

  out_min[hook(0, gid)] = (float4)(0x1.fffffep127f);
  out_max[hook(1, gid)] = (float4)(-0x1.fffffep127f);
}