//{"buf":0,"res":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void basic_conversion(global float4* buf, global int4* res) {
  res[hook(1, 0)] = convert_int4(buf[hook(0, 0)]);
}