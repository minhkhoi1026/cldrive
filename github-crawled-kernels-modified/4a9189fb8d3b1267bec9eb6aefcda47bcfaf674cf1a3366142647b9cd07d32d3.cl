//{"dstBuf":6,"dstOffset":4,"dstStride":5,"n":0,"srcBuf":3,"srcOffset":1,"srcStride":2,"tmp":8,"tmp[0]":9,"tmp[i]":10,"tmp[x]":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floatMatrixPotrf(const unsigned int n, const unsigned int srcOffset, const unsigned int srcStride, global float* srcBuf, const unsigned int dstOffset, const unsigned int dstStride, global float* dstBuf) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int active = x < n && y < n;

  local float tmp[16][16];

  if (y == 0 && active) {
    tmp[hook(8, x)][hook(7, y)] = sqrt(srcBuf[hook(3, srcOffset + x + y * srcStride)]);
    dstBuf[hook(6, dstOffset + x + y * dstStride)] = tmp[hook(8, x)][hook(7, y)] * (x == 0);
  }
  barrier(0x01);

  if (x == 0 && y > 0 && active) {
    tmp[hook(8, x)][hook(7, y)] = srcBuf[hook(3, srcOffset + x + y * srcStride)] / tmp[hook(8, 0)][hook(9, 0)];
    dstBuf[hook(6, dstOffset + x + y * dstStride)] = tmp[hook(8, x)][hook(7, y)];
  }
  barrier(0x01);

  if (x > 0 && y > 0 && x <= y && active) {
    tmp[hook(8, x)][hook(7, y)] = srcBuf[hook(3, srcOffset + x + y * srcStride)] - tmp[hook(8, 0)][hook(9, y)] * tmp[hook(8, 0)][hook(9, x)];
    dstBuf[hook(6, dstOffset + x + y * dstStride)] = tmp[hook(8, x)][hook(7, y)];
  }
  barrier(0x01);

  for (int i = 1; i < n; i++) {
    if (x >= i && y == i && active) {
      tmp[hook(8, x)][hook(7, y)] = sqrt(tmp[hook(8, x)][hook(7, y)]);
      dstBuf[hook(6, dstOffset + x + y * dstStride)] = tmp[hook(8, x)][hook(7, y)] * (x == i);
    }
    barrier(0x01);

    if (x == i && y > i && active) {
      tmp[hook(8, x)][hook(7, y)] /= tmp[hook(8, i)][hook(10, i)];
      dstBuf[hook(6, dstOffset + x + y * dstStride)] = tmp[hook(8, x)][hook(7, y)];
    }
    barrier(0x01);

    if (x > i && y > i && x <= y && active) {
      tmp[hook(8, x)][hook(7, y)] -= tmp[hook(8, i)][hook(10, y)] * tmp[hook(8, i)][hook(10, x)];
      dstBuf[hook(6, dstOffset + x + y * dstStride)] = tmp[hook(8, x)][hook(7, y)];
    }
    barrier(0x01);
  }
}