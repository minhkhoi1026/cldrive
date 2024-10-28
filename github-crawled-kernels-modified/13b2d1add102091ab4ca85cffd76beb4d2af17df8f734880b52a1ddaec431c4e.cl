//{"height":2,"lcostVol":0,"ldispMap":5,"maxDis":4,"rcostVol":1,"rdispMap":6,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dispsel_uchar(global const uchar* lcostVol, global const uchar* rcostVol, const int height, const int width, const int maxDis, global uchar* ldispMap, global uchar* rdispMap) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int offset = (y * width) + x;

  uchar lminCost = 255;
  uchar lminDis = 0;
  uchar rminCost = 255;
  uchar rminDis = 0;

  for (int d = 1; d < maxDis; d++) {
    uchar lcostData = lcostVol[hook(0, ((d * height) + y) * width + x)];
    uchar rcostData = rcostVol[hook(1, ((d * height) + y) * width + x)];
    if (lcostData < lminCost) {
      lminCost = lcostData;
      lminDis = d;
    }
    if (rcostData < rminCost) {
      rminCost = rcostData;
      rminDis = d;
    }
  }
  ldispMap[hook(5, offset)] = lminDis;
  rdispMap[hook(6, offset)] = rminDis;
}