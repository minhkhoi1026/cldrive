//{"offset":3,"pc4d":1,"pc8d":0,"rgba":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void splitPC8D(global float8* pc8d, global float4* pc4d, global float4* rgba, unsigned int offset) {
  unsigned int gX = get_global_id(0);

  float8 point = pc8d[hook(0, gX)];
  size_t pos = offset + gX;
  pc4d[hook(1, pos)] = point.lo;
  rgba[hook(2, pos)] = point.hi;
}