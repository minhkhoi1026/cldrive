//{"height":2,"lcostVol":0,"ldispMap":5,"maxDis":4,"rcostVol":1,"rdispMap":6,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dispsel_float(global const float* lcostVol, global const float* rcostVol, const int height, const int width, const int maxDis, global uchar* ldispMap, global uchar* rdispMap) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int dispMap_offset = y * width;
  int costVol_offset;

  float minCost = 0x1.fffffep127f;
  char minDis = 0;

  for (int d = 1; d < maxDis; d++) {
    float costData = lcostVol[hook(0, ((d * height) + y) * width + x)];
    if (costData < minCost) {
      minCost = costData;
      minDis = d;
    }
  }
  ldispMap[hook(5, dispMap_offset + x)] = minDis;

  minCost = 0x1.fffffep127f;
  minDis = 0;

  for (int d = 1; d < maxDis; d++) {
    float costData = rcostVol[hook(1, ((d * height) + y) * width + x)];
    if (costData < minCost) {
      minCost = costData;
      minDis = d;
    }
  }
  rdispMap[hook(6, dispMap_offset + x)] = minDis;
}