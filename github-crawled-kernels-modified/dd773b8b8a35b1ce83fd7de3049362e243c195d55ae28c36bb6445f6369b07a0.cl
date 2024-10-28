//{"c_g":2,"c_xg":3,"c_xxg":4,"dst":0,"dstStep":9,"height":7,"ig":6,"row":11,"smem":5,"src":1,"srcStep":10,"width":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void polynomialExpansion(global float* dst, global const float* src, global const float* c_g, global const float* c_xg, global const float* c_xxg, local float* smem, const float4 ig, const int height, const int width, int dstStep, int srcStep) {
  const int y = get_global_id(1);
  const int x = get_group_id(0) * ((int)get_local_size(0) - 2 * 5) + (int)get_local_id(0) - 5;

  dstStep /= sizeof(*dst);
  srcStep /= sizeof(*src);

  int xWarped;
  local float* row = smem + (int)get_local_id(0);

  if (y < height && y >= 0) {
    xWarped = min(max(x, 0), width - 1);

    row[hook(11, 0)] = src[hook(1, mad24(y, srcStep, xWarped))] * c_g[hook(2, 0)];
    row[hook(11, (int)get_local_size(0))] = 0.f;
    row[hook(11, 2 * (int)get_local_size(0))] = 0.f;

    for (int k = 1; k <= 5; ++k) {
      float t0 = src[hook(1, mad24(max(y - k, 0), srcStep, xWarped))];
      float t1 = src[hook(1, mad24(min(y + k, height - 1), srcStep, xWarped))];

      row[hook(11, 0)] += c_g[hook(2, k)] * (t0 + t1);
      row[hook(11, (int)get_local_size(0))] += c_xg[hook(3, k)] * (t1 - t0);
      row[hook(11, 2 * (int)get_local_size(0))] += c_xxg[hook(4, k)] * (t0 + t1);
    }
  }

  barrier(0x01);

  if (y < height && y >= 0 && (int)get_local_id(0) >= 5 && (int)get_local_id(0) + 5 < (int)get_local_size(0) && x < width) {
    float b1 = c_g[hook(2, 0)] * row[hook(11, 0)];
    float b3 = c_g[hook(2, 0)] * row[hook(11, (int)get_local_size(0))];
    float b5 = c_g[hook(2, 0)] * row[hook(11, 2 * (int)get_local_size(0))];
    float b2 = 0, b4 = 0, b6 = 0;

    for (int k = 1; k <= 5; ++k) {
      b1 += (row[hook(11, k)] + row[hook(11, -k)]) * c_g[hook(2, k)];
      b4 += (row[hook(11, k)] + row[hook(11, -k)]) * c_xxg[hook(4, k)];
      b2 += (row[hook(11, k)] - row[hook(11, -k)]) * c_xg[hook(3, k)];
      b3 += (row[hook(11, k + (int)get_local_size(0))] + row[hook(11, -k + (int)get_local_size(0))]) * c_g[hook(2, k)];
      b6 += (row[hook(11, k + (int)get_local_size(0))] - row[hook(11, -k + (int)get_local_size(0))]) * c_xg[hook(3, k)];
      b5 += (row[hook(11, k + 2 * (int)get_local_size(0))] + row[hook(11, -k + 2 * (int)get_local_size(0))]) * c_g[hook(2, k)];
    }

    dst[hook(0, mad24(y, dstStep, xWarped))] = b3 * ig.s0;
    dst[hook(0, mad24(height + y, dstStep, xWarped))] = b2 * ig.s0;
    dst[hook(0, mad24(2 * height + y, dstStep, xWarped))] = b1 * ig.s1 + b5 * ig.s2;
    dst[hook(0, mad24(3 * height + y, dstStep, xWarped))] = b1 * ig.s1 + b4 * ig.s2;
    dst[hook(0, mad24(4 * height + y, dstStep, xWarped))] = b6 * ig.s3;
  }
}