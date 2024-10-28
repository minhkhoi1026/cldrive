//{"H":3,"W":2,"flag":4,"p1":5,"p2":6,"pData":7,"pOut":8,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t smp = 0x10;
kernel void Mouse(int x, int y, int W, int H, int flag, int p1, int p2, global int* pData) {
  int w4 = W >> 2;
  int h4 = H >> 2;
  int x4 = x >> 2;
  int y4 = y >> 2;
  global float* pOut = (global float*)(pData + 32) + (w4 * h4) * (pData[hook(7, 0)] & 1);
  pData[hook(7, 0)]++;
  if (x < 0 || y < 0 || x >= W || y >= H)
    return;
  if (flag && pData[hook(7, 1)] != x4 && pData[hook(7, 2)] != y4) {
    int i, j;
    for (i = -50; i <= 50; ++i)
      for (j = -50; j <= 50; ++j) {
        float r = (p2 + 1.0f) / 30.0f;
        float W = native_exp(-0.5f * (i * i + j * j) / (r * r));
        int xx = x4 + i;
        int yy = y4 + j;
        if (xx >= 0 & xx < w4 & yy >= 0 & yy < h4)
          pOut[hook(8, xx + yy * w4)] -= W * 150;
      }
    pData[hook(7, 1)] = x4;
    pData[hook(7, 2)] = y4;
  }
}