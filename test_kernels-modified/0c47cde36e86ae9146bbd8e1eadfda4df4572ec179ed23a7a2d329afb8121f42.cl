//{"cols":2,"dst":1,"dst_offset":7,"dst_step":5,"rows":3,"src":0,"src_offset":6,"src_step":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void columnSum_C1_D5(global float* src, global float* dst, int cols, int rows, int src_step, int dst_step, int src_offset, int dst_offset) {
  const int x = get_global_id(0);

  if (x < cols) {
    int srcIdx = x + src_offset;
    int dstIdx = x + dst_offset;

    float sum = 0;

    for (int y = 0; y < rows; ++y) {
      sum += src[hook(0, srcIdx)];
      dst[hook(1, dstIdx)] = sum;
      srcIdx += src_step;
      dstIdx += dst_step;
    }
  }
}