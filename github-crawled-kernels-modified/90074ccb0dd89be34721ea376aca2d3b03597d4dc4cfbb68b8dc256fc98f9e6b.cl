//{"height":3,"pIn_a":0,"pIn_b":1,"pOut":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EWMul_DiffDim_8U(global const uchar* pIn_a, global const uchar* pIn_b, const int width, const int height, global uchar* pOut) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int d = get_global_id(2);

  const int offset2D = mul24(y, width) + x;
  const int offset3D = mul24(mul24(d, height) + y, width) + x;

  pOut[hook(4, offset3D)] = mul24(pIn_a[hook(0, offset2D)], pIn_b[hook(1, offset3D)]);
}