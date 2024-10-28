//{"data":2,"in":0,"out":1,"radius":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void boxFilter(global float* in, global float* out, local float* data, int radius) {
  int gXdim = get_global_size(0);
  int gYdim = get_global_size(1);
  int lXdim = get_local_size(0);
  int lYdim = get_local_size(1);
  int lWidth = lXdim + 2 * radius;

  int gX = get_global_id(0);
  int gY = get_global_id(1);
  int lX = get_local_id(0);
  int lY = get_local_id(1);

  for (int y = lY, iy = gY - radius; y < lYdim + 2 * radius; y += lYdim, iy += lYdim) {
    for (int x = lX, ix = gX - radius; x < lXdim + 2 * radius; x += lXdim, ix += lXdim) {
      unsigned int flag = (ix >= 0 && iy >= 0 && ix < gXdim && iy < gYdim);
      data[hook(2, y * lWidth + x)] = select(0.f, in[hook(0, iy * gXdim + ix)], flag);
    }
  }
  barrier(0x01);

  float sum = 0.f;
  for (int fRow = lY; fRow <= lY + 2 * radius; ++fRow)
    for (int fCol = lX; fCol <= lX + 2 * radius; ++fCol)
      sum += data[hook(2, fRow * lWidth + fCol)];

  int2 c0 = {gX - radius - 1, gY - radius - 1};
  int2 c1 = {min(gX + radius, gXdim - 1), min(gY + radius, gYdim - 1)};
  int2 outOfBounds = c0 < 0;

  int2 d = c1 - select(c0, -1, outOfBounds);
  float n = d.x * d.y;

  out[hook(1, gY * gXdim + gX)] = sum / n;
}