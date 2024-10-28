//{"c_btvRegWeights":8,"channels":7,"dst":1,"dst_step":3,"ksize":6,"src":0,"src_col":5,"src_row":4,"src_step":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float diffSign(float a, float b) {
  return a > b ? 1.0f : a < b ? -1.0f : 0.0f;
}

float4 diffSign4(float4 a, float4 b) {
  float4 pos;
  pos.x = a.x > b.x ? 1.0f : a.x < b.x ? -1.0f : 0.0f;
  pos.y = a.y > b.y ? 1.0f : a.y < b.y ? -1.0f : 0.0f;
  pos.z = a.z > b.z ? 1.0f : a.z < b.z ? -1.0f : 0.0f;
  pos.w = 0.0f;
  return pos;
}

kernel void calcBtvRegularizationKernel(global float* src, global float* dst, int src_step, int dst_step, int src_row, int src_col, int ksize, int channels, constant float* c_btvRegWeights) {
  int x = get_global_id(0) + ksize;
  int y = get_global_id(1) + ksize;

  if ((y < src_row - ksize) && (x < src_col - ksize)) {
    if (channels == 1) {
      const float srcVal = src[hook(0, y * src_step + x)];
      float dstVal = 0.0f;

      for (int m = 0, count = 0; m <= ksize; ++m) {
        for (int l = ksize; l + m >= 0; --l, ++count) {
          dstVal = dstVal + c_btvRegWeights[hook(8, count)] * (diffSign(srcVal, src[hook(0, (y + m) * src_step + (x + l))]) - diffSign(src[hook(0, (y - m) * src_step + (x - l))], srcVal));
        }
      }
      dst[hook(1, y * dst_step + x)] = dstVal;
    } else {
      float4 srcVal = vload4(0, src + y * src_step + 4 * x);
      float4 dstVal = 0.f;

      for (int m = 0, count = 0; m <= ksize; ++m) {
        for (int l = ksize; l + m >= 0; --l, ++count) {
          float4 src1;
          src1.x = src[hook(0, (y + m) * src_step + 4 * (x + l) + 0)];
          src1.y = src[hook(0, (y + m) * src_step + 4 * (x + l) + 1)];
          src1.z = src[hook(0, (y + m) * src_step + 4 * (x + l) + 2)];
          src1.w = src[hook(0, (y + m) * src_step + 4 * (x + l) + 3)];

          float4 src2;
          src2.x = src[hook(0, (y - m) * src_step + 4 * (x - l) + 0)];
          src2.y = src[hook(0, (y - m) * src_step + 4 * (x - l) + 1)];
          src2.z = src[hook(0, (y - m) * src_step + 4 * (x - l) + 2)];
          src2.w = src[hook(0, (y - m) * src_step + 4 * (x - l) + 3)];

          dstVal = dstVal + c_btvRegWeights[hook(8, count)] * (diffSign4(srcVal, src1) - diffSign4(src2, srcVal));
        }
      }
      vstore4(dstVal, 0, dst + y * dst_step + 4 * x);
    }
  }
}