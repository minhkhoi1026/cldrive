//{"H":3,"W":2,"flag":4,"p1":5,"p2":6,"pD":7,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t smp = 0x10;
kernel void Mouse(int x, int y, int W, int H, int flag, int p1, int p2, global float2* pD) {
  if (flag) {
    pD[hook(7, 0)] = (float2)(x, y);
  }
  pD[hook(7, 1)].x = (float)p1 / (float)(1 << 5);
  pD[hook(7, 1)].y = (float)p2 / (float)(1 << 5);
}