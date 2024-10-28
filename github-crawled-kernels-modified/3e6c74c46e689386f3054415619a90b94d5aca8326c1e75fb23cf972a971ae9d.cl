//{"cols":4,"filter":2,"filterWidth":5,"imageIn":0,"imageOut":1,"localHeight":7,"localImage":6,"localWidth":8,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolution(global float* imageIn, global float* imageOut, constant float* filter, int rows, int cols, int filterWidth, local float* localImage, int localHeight, int localWidth) {
  int filterRadius = filterWidth / 2;
  int padding = filterRadius * 2;

  int groupStartCol = get_group_id(0) * get_local_size(0);
  int groupStartRow = get_group_id(1) * get_local_size(1);

  int localCol = get_local_id(0);
  int localRow = get_local_id(1);

  int globalCol = groupStartCol + localCol;
  int globalRow = groupStartRow + localRow;
  for (int i = localRow; i < localHeight; i += get_local_size(1)) {
    int curRow = groupStartRow + i;

    for (int j = localCol; j < localWidth; j += get_local_size(0)) {
      int curCol = groupStartCol + j;

      if (curRow < rows && curCol < cols) {
        localImage[hook(6, i * localWidth + j)] = imageIn[hook(0, curRow * cols + curCol)];
      }
    }
  }
  barrier(0x01);

  if (globalRow < rows - padding && globalCol < cols - padding) {
    float sum = 0.0f;
    int filterIdx = 0;

    for (int i = localRow; i < localRow + filterWidth; i++) {
      int offset = i * localWidth;
      for (int j = localCol; j < localCol + filterWidth; j++) {
        sum += localImage[hook(6, offset + j)] * filter[hook(2, filterIdx++)];
      }
    }
    imageOut[hook(1, (globalRow + filterRadius) * cols + (globalCol + filterRadius))] = sum;
  }

  return;
}