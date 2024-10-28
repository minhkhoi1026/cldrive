//{"aTile":5,"bTile":6,"input":1,"inputDimensions":3,"mask":2,"maskDimensions":4,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simpleConvolution(global unsigned int* output, global unsigned int* input, global float* mask, const uint2 inputDimensions, const uint2 maskDimensions, local unsigned int* aTile, local float* bTile) {
  unsigned int maskWidth = maskDimensions.x;
  unsigned int maskHeight = maskDimensions.y;
  int tid = get_global_id(0);
  unsigned int width = inputDimensions.x;
  unsigned int height = inputDimensions.y;

  int x = tid / width;
  int y = tid % width;

  int lx = get_local_id(0) / maskWidth;
  int ly = get_local_id(0) % maskWidth;

  bTile[hook(6, lx * maskWidth + ly)] = mask[hook(2, lx * maskWidth + ly)];

  aTile[hook(5, lx * 2 * maskWidth + ly)] = (x - maskWidth / 2 >= 0) && (x - maskWidth / 2 < width) && (y - maskWidth / 2 >= 0) && (y - maskWidth / 2 < height) ? input[hook(1, (x - maskWidth / 2) * width + y - maskWidth / 2)] : 0;
  aTile[hook(5, lx * 2 * maskWidth + (maskWidth + ly))] = (x - maskWidth / 2 >= 0) && (x - maskWidth / 2 < width) && (y + maskWidth / 2 >= 0) && (y + maskWidth / 2 < height) ? input[hook(1, (x - maskWidth / 2) * width + y + maskWidth / 2)] : 0;
  aTile[hook(5, (maskWidth + lx) * 2 * maskWidth + ly)] = (x + maskWidth / 2 >= 0) && (x + maskWidth / 2 < width) && (y - maskWidth / 2 >= 0) && (y - maskWidth / 2 < height) ? input[hook(1, (x + maskWidth / 2) * width + y - maskWidth / 2)] : 0;
  aTile[hook(5, (maskWidth + lx) * 2 * maskWidth + (maskWidth + ly))] = (x + maskWidth / 2 >= 0) && (x + maskWidth / 2 < width) && (y + maskWidth / 2 >= 0) && (y + maskWidth / 2 < height) ? input[hook(1, (x + maskWidth / 2) * width + y + maskWidth / 2)] : 0;
  barrier(0x01);
  float sumFX = 0;

  for (int i = 1; i < maskWidth; i++)
    for (int j = 1; j < maskHeight; j++)
      sumFX += ((float)aTile[hook(5, (lx + i) * 2 * maskWidth + (ly + j))] * bTile[hook(6, (maskWidth - i) * maskWidth + (maskHeight - j))]);

  sumFX += 0.5f;
  output[hook(0, tid)] = (unsigned int)sumFX;
}