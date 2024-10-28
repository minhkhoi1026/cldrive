//{"dst":1,"src_0":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void native_exp10_float4(global float4* src_0, global float4* dst) {
  int gid = get_global_id(0);
  dst[hook(1, gid)] = native_exp10(src_0[hook(0, gid)]);
}