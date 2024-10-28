//{"c_g":6,"c_xg":7,"c_xxg":8,"cols":5,"dst":2,"dstStep":3,"ig":10,"row":11,"rows":4,"smem":9,"src":0,"srcStep":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void polynomialExpansion(global const float* src, int srcStep, global float* dst, int dstStep, const int rows, const int cols, global const float* c_g, global const float* c_xg, global const float* c_xxg, local float* smem, const float4 ig) {
  const int y = get_global_id(1);
  const int x = get_group_id(0) * ((int)get_local_size(0) - 2 * 5) + (int)get_local_id(0) - 5;

  int xWarped;
  local float* row = smem + (int)get_local_id(0);

  if (y < rows && y >= 0) {
    xWarped = min(max(x, 0), cols - 1);

    row[hook(11, 0)] = src[hook(0, mad24(y, srcStep, xWarped))] * c_g[hook(6, 0)];
    row[hook(11, (int)get_local_size(0))] = 0.f;
    row[hook(11, 2 * (int)get_local_size(0))] = 0.f;

    for (int k = 1; k <= 5; ++k) {
      float t0 = src[hook(0, mad24(max(y - k, 0), srcStep, xWarped))];
      float t1 = src[hook(0, mad24(min(y + k, rows - 1), srcStep, xWarped))];

      row[hook(11, 0)] += c_g[hook(6, k)] * (t0 + t1);
      row[hook(11, (int)get_local_size(0))] += c_xg[hook(7, k)] * (t1 - t0);
      row[hook(11, 2 * (int)get_local_size(0))] += c_xxg[hook(8, k)] * (t0 + t1);
    }
  }

  barrier(0x01);

  if (y < rows && y >= 0 && (int)get_local_id(0) >= 5 && (int)get_local_id(0) + 5 < (int)get_local_size(0) && x < cols) {
    float b1 = c_g[hook(6, 0)] * row[hook(11, 0)];
    float b3 = c_g[hook(6, 0)] * row[hook(11, (int)get_local_size(0))];
    float b5 = c_g[hook(6, 0)] * row[hook(11, 2 * (int)get_local_size(0))];
    float b2 = 0, b4 = 0, b6 = 0;

    for (int k = 1; k <= 5; ++k) {
      b1 += (row[hook(11, k)] + row[hook(11, -k)]) * c_g[hook(6, k)];
      b4 += (row[hook(11, k)] + row[hook(11, -k)]) * c_xxg[hook(8, k)];
      b2 += (row[hook(11, k)] - row[hook(11, -k)]) * c_xg[hook(7, k)];
      b3 += (row[hook(11, k + (int)get_local_size(0))] + row[hook(11, -k + (int)get_local_size(0))]) * c_g[hook(6, k)];
      b6 += (row[hook(11, k + (int)get_local_size(0))] - row[hook(11, -k + (int)get_local_size(0))]) * c_xg[hook(7, k)];
      b5 += (row[hook(11, k + 2 * (int)get_local_size(0))] + row[hook(11, -k + 2 * (int)get_local_size(0))]) * c_g[hook(6, k)];
    }

    dst[hook(2, mad24(y, dstStep, xWarped))] = (float)(b3 * ig.s0);
    dst[hook(2, mad24(rows + y, dstStep, xWarped))] = (float)(b2 * ig.s0);
    dst[hook(2, mad24(2 * rows + y, dstStep, xWarped))] = (float)(b1 * ig.s1 + b5 * ig.s2);
    dst[hook(2, mad24(3 * rows + y, dstStep, xWarped))] = (float)(b1 * ig.s1 + b4 * ig.s2);
    dst[hook(2, mad24(4 * rows + y, dstStep, xWarped))] = (float)(b6 * ig.s3);
  }
}