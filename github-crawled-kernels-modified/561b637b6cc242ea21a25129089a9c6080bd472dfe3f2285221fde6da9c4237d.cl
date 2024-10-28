//{"cols":1,"mean":0,"rows":2,"window_count":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelFinalizeSum(global float* mean, int cols, int rows, int window_count) {
  int xIndex = get_global_id(0);
  if (xIndex >= cols)
    return;

  float sum = 0, sum2 = 0;
  float2 minmaxv = (float2)(0x1.fffffep127f, -0x1.fffffep127f);
  for (int i = 0; i < rows; i++) {
    sum += mean[hook(0, cols * i + xIndex)];
  }
  mean[hook(0, xIndex)] = sum / window_count;
}