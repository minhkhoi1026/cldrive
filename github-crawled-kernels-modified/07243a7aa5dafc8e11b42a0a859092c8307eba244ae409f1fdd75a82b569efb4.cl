//{"depth":0,"f":2,"pCloud":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void depthTo3D(global ushort* depth, global float4* pCloud, float f) {
  unsigned int cols = get_global_size(0);
  unsigned int rows = get_global_size(1);

  unsigned int gX = get_global_id(0);
  unsigned int gY = get_global_id(1);

  unsigned int idx = gY * cols + gX;

  float d = convert_float(depth[hook(0, idx)]);
  float4 point = {(gX - (cols - 1) / 2.f) * d / f, (gY - (rows - 1) / 2.f) * d / f, d, 1.f};

  pCloud[hook(1, idx)] = point;
}