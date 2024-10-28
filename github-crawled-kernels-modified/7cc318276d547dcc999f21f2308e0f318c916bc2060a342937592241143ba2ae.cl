//{"dst_offset":5,"dst_step":4,"dstptr":3,"frameSize":6,"kernelSize":7,"sigma_depth2_inv_half":9,"sigma_spatial2_inv_half":8,"srcCenterRow":10,"srcRow":11,"src_offset":2,"src_step":1,"srcptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float3 reproject(float3 p, float2 fxyinv, float2 cxy) {
  float2 pp = p.z * (p.xy - cxy) * fxyinv;
  return (float3)(pp, p.z);
}

typedef float4 float4;

kernel void customBilateral(global const char* srcptr, int src_step, int src_offset, global char* dstptr, int dst_step, int dst_offset, const int2 frameSize, const int kernelSize, const float sigma_spatial2_inv_half, const float sigma_depth2_inv_half) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x >= frameSize.x || y >= frameSize.y)
    return;

  global const float* srcCenterRow = (global const float*)(srcptr + src_offset + y * src_step);
  float value = srcCenterRow[hook(10, x)];

  int tx = min(x - kernelSize / 2 + kernelSize, frameSize.x - 1);
  int ty = min(y - kernelSize / 2 + kernelSize, frameSize.y - 1);

  float sum1 = 0;
  float sum2 = 0;

  for (int cy = max(y - kernelSize / 2, 0); cy < ty; ++cy) {
    global const float* srcRow = (global const float*)(srcptr + src_offset + cy * src_step);
    for (int cx = max(x - kernelSize / 2, 0); cx < tx; ++cx) {
      float depth = srcRow[hook(11, cx)];

      float space2 = convert_float((x - cx) * (x - cx) + (y - cy) * (y - cy));
      float color2 = (value - depth) * (value - depth);

      float weight = native_exp(-(space2 * sigma_spatial2_inv_half + color2 * sigma_depth2_inv_half));

      sum1 += depth * weight;
      sum2 += weight;
    }
  }

  global float* dst = (global float*)(dstptr + dst_offset + y * dst_step + x * sizeof(float));
  *dst = sum1 / sum2;
}