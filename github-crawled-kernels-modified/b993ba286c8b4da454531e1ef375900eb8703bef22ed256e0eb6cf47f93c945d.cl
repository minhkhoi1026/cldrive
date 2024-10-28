//{"cl_d_src":1,"d_b":5,"d_c":0,"d_g":4,"d_r":3,"pixels":2,"sData":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int divRndUp(int n, int d) {
  return (n / d) + ((n % d) ? 1 : 0);
}
void storeComponents(global int* d_r, global int* d_g, global int* d_b, int r, int g, int b, int pos) {
  d_r[hook(3, pos)] = r - 128;
  d_g[hook(4, pos)] = g - 128;
  d_b[hook(5, pos)] = b - 128;
}
void storeComponent(global int* d_c, const int c, int pos) {
  d_c[hook(0, pos)] = c - 128;
}

kernel void c_CopySrcToComponent(global int* d_c, global unsigned char* cl_d_src, int pixels) {
  int x = get_local_id(0);
  int gX = get_local_size(0) * (get_global_id(0) / get_local_size(0));

  local unsigned char sData[256];

  sData[hook(6, x)] = cl_d_src[hook(1, gX + x)];

  barrier(0x01);

  int c;

  c = (int)(sData[hook(6, x)]);

  int globalOutputPosition = gX + x;
  if (globalOutputPosition < pixels) {
    storeComponent(d_c, c, globalOutputPosition);
  }
}