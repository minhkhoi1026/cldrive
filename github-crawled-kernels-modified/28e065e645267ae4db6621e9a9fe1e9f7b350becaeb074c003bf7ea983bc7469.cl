//{"data":2,"out":1,"radius":3,"sat":0,"scaling":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void boxFilterSAT_Tr(global float* sat, global float4* out, local float* data, int radius, float scaling) {
  int gXdim = get_global_size(0);
  int gYdim = get_global_size(1);
  int lXdim = get_local_size(0);
  int lYdim = get_local_size(1);

  int gX = get_global_id(0);
  int gY = get_global_id(1);
  int lX = get_local_id(0);
  int lY = get_local_id(1);
  int wgX = get_group_id(0);
  int wgY = get_group_id(1);

  int2 c0 = {gX - radius - 1, gY - radius - 1};
  int2 c1 = {min(gX + radius, gXdim - 1), min(gY + radius, gYdim - 1)};
  int2 outOfBounds = isless(convert_float2(c0), 0.f);

  float sum = 0.f;
  sum += select(sat[hook(0, c0.y * gXdim + c0.x)], 0.f, outOfBounds.x || outOfBounds.y);
  sum -= select(sat[hook(0, c0.y * gXdim + c1.x)], 0.f, outOfBounds.y);
  sum -= select(sat[hook(0, c1.y * gXdim + c0.x)], 0.f, outOfBounds.x);
  sum += sat[hook(0, c1.y * gXdim + c1.x)];

  int2 d = c1 - select(c0, -1, outOfBounds);
  float n = d.x * d.y;

  int idx = lY * lXdim + lX;

  data[hook(2, idx)] = scaling * sum / n;
  barrier(0x01);

  if (idx < 16 * 16 / 4) {
    int iy = idx % 4;
    int ix = idx / 4;
    int base = 4 * iy * lXdim + ix;
    float4 pixels = {data[hook(2, base)], data[hook(2, base + lXdim)], data[hook(2, base + 2 * lXdim)], data[hook(2, base + 3 * lXdim)]};

    out[hook(1, (wgX * lXdim + ix) * gYdim / 4 + (wgY * lYdim / 4 + iy))] = pixels;
  }
}