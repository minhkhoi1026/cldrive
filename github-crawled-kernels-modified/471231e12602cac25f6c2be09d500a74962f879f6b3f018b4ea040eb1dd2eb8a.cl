//{"edges":4,"gradient":3,"height":8,"in":0,"primary_treshold":5,"secondary_treshold":6,"sobelx":1,"sobely":2,"width":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 read(global const uchar4* in, int x, int y, int width) {
  return convert_float4(in[hook(0, x + width * y)]);
}

float4 compute_sobelx(global const uchar4* in, int x, int y, int w) {
  return -2 * read(in, x - 1, y - 1, w) - read(in, x - 1, y, w) - read(in, x - 1, y + 1, w) + 2 * read(in, x + 1, y - 1, w) + read(in, x + 1, y, w) + read(in, x + 1, y + 1, w);
}

float4 compute_sobely(global const uchar4* in, int x, int y, int w) {
  return -2 * read(in, x - 1, y - 1, w) - read(in, x, y - 1, w) - read(in, x + 1, y - 1, w) + 2 * read(in, x - 1, y + 1, w) + read(in, x, y + 1, w) + read(in, x + 1, y + 1, w);
}

kernel void sobel(global const uchar4* in, global uchar4* sobelx, global uchar4* sobely, global uchar4* gradient, global uchar4* edges, float primary_treshold, float secondary_treshold, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int idx = x + width * y;

  if (x >= width || y >= height) {
    return;
  }

  if (x == 0 || y == 0 || x == width - 1 || y == height - 1) {
    sobelx[hook(1, idx)] = (uchar4)(0, 0, 0, 255);
    sobely[hook(2, idx)] = (uchar4)(0, 0, 0, 255);
    gradient[hook(3, idx)] = (uchar4)(0, 0, 0, 255);
    edges[hook(4, idx)] = (uchar4)(0, 0, 0, 255);
    return;
  }

  const float4 sx = compute_sobelx(in, x, y, width);
  const float4 sy = compute_sobely(in, x, y, width);
  const float grad = (fabs(sx.x) + fabs(sx.y) + fabs(sx.z) + fabs(sy.x) + fabs(sy.y) + fabs(sy.z)) / 3.0;

  sobelx[hook(1, idx)] = convert_uchar4(sx);
  sobely[hook(2, idx)] = convert_uchar4(sy);

  const unsigned char gradu = convert_uchar(grad);
  gradient[hook(3, idx)] = (uchar4)(gradu, gradu, gradu, 255);

  const bool prim_edge = grad > primary_treshold;
  const bool sec_edge = grad > secondary_treshold;
  const uchar edge = 255 * prim_edge | 125 * sec_edge;

  edges[hook(4, idx)] = (uchar4)(edge, edge, edge, 255);
}