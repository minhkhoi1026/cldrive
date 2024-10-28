//{"dim0":2,"dim1":3,"in":1,"localMem":4,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uchar4 convertYVUtoRGBA(int y, int u, int v) {
  uchar4 ret;
  y -= 16;
  u -= 128;
  v -= 128;
  int b = y + (int)(1.772f * u);
  int g = y - (int)(0.344f * u + 0.714f * v);
  int r = y + (int)(1.402f * v);
  ret.x = r > 255 ? 255 : r < 0 ? 0 : r;
  ret.y = g > 255 ? 255 : g < 0 ? 0 : g;
  ret.z = b > 255 ? 255 : b < 0 ? 0 : b;
  ret.w = 255;
  return ret;
}

kernel void laplacian(global uchar4* out, global uchar4* in, int dim0, int dim1) {
  local uchar4 localMem[((16 + (2 * 1)) * (16 + (2 * 1)))];

  int gx = get_global_id(0);
  int gy = get_global_id(1);

  int lx = get_local_id(0);
  int ly = get_local_id(1);

  int lx2 = lx + 16;
  int ly2 = ly + 16;
  int gx2 = gx + 16;
  int gy2 = gy + 16;
  int i = lx + 1;
  int j = ly + 1;

  int gx_ = clamp((gx - 1), 0, (int)dim0 - 1);
  int gy_ = clamp((gy - 1), 0, (int)dim1 - 1);
  localMem[hook(4, ((ly) * (16 + (2 * 1)) + (lx)))] = in[hook(1, ((gy_) * dim0 + (gx_)))];
  ;
  if (lx < (2 * 1)) {
    int gx_ = clamp((gx2 - 1), 0, (int)dim0 - 1);
    int gy_ = clamp((gy - 1), 0, (int)dim1 - 1);
    localMem[hook(4, ((ly) * (16 + (2 * 1)) + (lx2)))] = in[hook(1, ((gy_) * dim0 + (gx_)))];
    ;
  }
  if (ly < (2 * 1)) {
    int gx_ = clamp((gx - 1), 0, (int)dim0 - 1);
    int gy_ = clamp((gy2 - 1), 0, (int)dim1 - 1);
    localMem[hook(4, ((ly2) * (16 + (2 * 1)) + (lx)))] = in[hook(1, ((gy_) * dim0 + (gx_)))];
    ;
  }
  if (lx < (2 * 1) && ly < (2 * 1)) {
    int gx_ = clamp((gx2 - 1), 0, (int)dim0 - 1);
    int gy_ = clamp((gy2 - 1), 0, (int)dim1 - 1);
    localMem[hook(4, ((ly2) * (16 + (2 * 1)) + (lx2)))] = in[hook(1, ((gy_) * dim0 + (gx_)))];
    ;
  }
  barrier(0x01);
  float4 C = convert_float4(localMem[hook(4, ((j) * (16 + (2 * 1)) + (i)))]);
  float4 N = convert_float4(localMem[hook(4, ((j - 1) * (16 + (2 * 1)) + (i)))]);
  float4 NW = convert_float4(localMem[hook(4, ((j - 1) * (16 + (2 * 1)) + (i - 1)))]);
  float4 W = convert_float4(localMem[hook(4, ((j) * (16 + (2 * 1)) + (i - 1)))]);
  float4 SW = convert_float4(localMem[hook(4, ((j + 1) * (16 + (2 * 1)) + (i - 1)))]);
  float4 S = convert_float4(localMem[hook(4, ((j + 1) * (16 + (2 * 1)) + (i)))]);
  float4 SE = convert_float4(localMem[hook(4, ((j + 1) * (16 + (2 * 1)) + (i + 1)))]);
  float4 E = convert_float4(localMem[hook(4, ((j) * (16 + (2 * 1)) + (i + 1)))]);
  float4 NE = convert_float4(localMem[hook(4, ((j - 1) * (16 + (2 * 1)) + (i + 1)))]);

  float4 acc = (float4)0.0f;
  acc = 8 * C - N - NW - W - SW - S - SE - E - NE;
  acc.w = 255.0f;

  if (gx < dim0 && gy < dim1) {
    out[hook(0, gy * dim0 + gx)] = convert_uchar4(acc);
  }
}