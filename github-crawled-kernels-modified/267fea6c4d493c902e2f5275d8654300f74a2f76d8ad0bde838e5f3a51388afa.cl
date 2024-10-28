//{"depth":0,"fDepth":1,"scaling":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void depth_Ushort2Float(global ushort4* depth, global float4* fDepth, float scaling) {
  unsigned int gX = get_global_id(0);

  fDepth[hook(1, gX)] = convert_float4(depth[hook(0, gX)]) * scaling;
}