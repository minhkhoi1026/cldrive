//{"colors":5,"indexOffset":3,"numObjects":1,"numPairs":4,"pairs":2,"posOrnColors":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void colorPairsKernel2(global float4* posOrnColors, int numObjects, global const int4* pairs, int indexOffset, int numPairs) {
  int iPairId = get_global_id(0);
  if (iPairId >= numPairs)
    return;
  global float4* colors = &posOrnColors[hook(0, numObjects * 2)];

  int iObjectA = pairs[hook(2, iPairId)].x - indexOffset;
  int iObjectB = pairs[hook(2, iPairId)].y - indexOffset;
  colors[hook(5, iObjectA)] = (float4)(1, 0, 0, 1);
  colors[hook(5, iObjectB)] = (float4)(1, 0, 0, 1);
}