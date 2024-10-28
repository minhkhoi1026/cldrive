//{"colors":3,"numObjects":1,"posOrnColors":0,"positions":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void moveObjectsKernel(global float4* posOrnColors, int numObjects) {
  int iGID = get_global_id(0);
  if (iGID >= numObjects)
    return;
  global float4* positions = &posOrnColors[hook(0, 0)];
  if (iGID < 0.5 * numObjects) {
    positions[hook(2, iGID)].y += 0.01f;
  }
  global float4* colors = &posOrnColors[hook(0, numObjects * 2)];
  colors[hook(3, iGID)] = (float4)(0, 0, 1, 1);
}