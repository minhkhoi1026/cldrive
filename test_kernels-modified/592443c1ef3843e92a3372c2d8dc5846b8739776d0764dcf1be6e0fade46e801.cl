//{"inputWidth":2,"outputWidth":3,"poolingTable":0,"stride":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CreateMaxPoolingTable(global int* poolingTable, const int stride, const int inputWidth, const int outputWidth) {
  const int i = get_global_id(0);

  const int outputArea = outputWidth * outputWidth;

  if (i < outputArea) {
    int iOutputRow = i / outputWidth;
    int iOutputCol = i % outputWidth;

    int iInputTopLeft = iOutputRow * stride * inputWidth + iOutputCol * stride;
    int iInputTopRight = iInputTopLeft + 1;
    int iInputBottomLeft = iInputTopLeft + inputWidth;
    int iInputBottomRight = iInputBottomLeft + 1;

    poolingTable[hook(0, 4 * i + 0)] = iInputTopLeft;
    poolingTable[hook(0, 4 * i + 1)] = iInputTopRight;
    poolingTable[hook(0, 4 * i + 2)] = iInputBottomLeft;
    poolingTable[hook(0, 4 * i + 3)] = iInputBottomRight;
  }
}