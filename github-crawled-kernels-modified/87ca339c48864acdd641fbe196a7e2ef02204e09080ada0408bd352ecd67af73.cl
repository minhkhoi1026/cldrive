//{"depthDown_cols":9,"depthDown_offset":7,"depthDown_rows":8,"depthDown_step":6,"depthDownptr":5,"depth_cols":4,"depth_offset":2,"depth_rows":3,"depth_step":1,"depthptr":0,"sigma":10,"srcCenterRow":11,"srcRow":12}
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

kernel void pyrDownBilateral(global const char* depthptr, int depth_step, int depth_offset, int depth_rows, int depth_cols, global char* depthDownptr, int depthDown_step, int depthDown_offset, int depthDown_rows, int depthDown_cols, const float sigma) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x >= depthDown_cols || y >= depthDown_rows)
    return;

  const float sigma3 = sigma * 3;
  const int D = 5;

  global const float* srcCenterRow = (global const float*)(depthptr + depth_offset + (2 * y) * depth_step);

  float center = srcCenterRow[hook(11, 2 * x)];

  int sx = max(0, 2 * x - D / 2), ex = min(2 * x - D / 2 + D, depth_cols - 1);
  int sy = max(0, 2 * y - D / 2), ey = min(2 * y - D / 2 + D, depth_rows - 1);

  float sum = 0;
  int count = 0;

  for (int iy = sy; iy < ey; iy++) {
    global const float* srcRow = (global const float*)(depthptr + depth_offset + (iy)*depth_step);
    for (int ix = sx; ix < ex; ix++) {
      float val = srcRow[hook(12, ix)];
      if (fabs(val - center) < sigma3) {
        sum += val;
        count++;
      }
    }
  }

  global float* downRow = (global float*)(depthDownptr + depthDown_offset + y * depthDown_step + x * sizeof(float));

  *downRow = (count == 0) ? 0 : sum / convert_float(count);
}