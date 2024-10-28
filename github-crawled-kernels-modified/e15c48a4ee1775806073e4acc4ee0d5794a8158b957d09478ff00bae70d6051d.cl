//{"cl_d_src":3,"d_b":2,"d_c":5,"d_g":1,"d_r":0,"pixels":4,"sData":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int divRndUp(int n, int d) {
  return (n / d) + ((n % d) ? 1 : 0);
}
void storeComponents(global int* d_r, global int* d_g, global int* d_b, int r, int g, int b, int pos) {
  d_r[hook(0, pos)] = r - 128;
  d_g[hook(1, pos)] = g - 128;
  d_b[hook(2, pos)] = b - 128;
}
void storeComponent(global int* d_c, const int c, int pos) {
  d_c[hook(5, pos)] = c - 128;
}

kernel void c_CopySrcToComponents(global int* d_r, global int* d_g, global int* d_b, global unsigned char* cl_d_src, int pixels) {
  int x = get_local_id(0);
  int gX = get_local_size(0) * (get_global_id(0) / get_local_size(0));

  local unsigned char sData[256 * 3];

  sData[hook(6, 3 * x + 0)] = cl_d_src[hook(3, gX * 3 + 3 * x + 0)];
  sData[hook(6, 3 * x + 1)] = cl_d_src[hook(3, gX * 3 + 3 * x + 1)];
  sData[hook(6, 3 * x + 2)] = cl_d_src[hook(3, gX * 3 + 3 * x + 2)];

  barrier(0x01);

  int r, g, b;
  int offset = x * 3;
  r = (int)(sData[hook(6, offset)]);
  g = (int)(sData[hook(6, offset + 1)]);
  b = (int)(sData[hook(6, offset + 2)]);

  int globalOutputPosition = gX + x;
  if (globalOutputPosition < pixels) {
    storeComponents(d_r, d_g, d_b, r, g, b, globalOutputPosition);
  }
}