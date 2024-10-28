//{"block_count_x":7,"in":0,"line_width":6,"out":1,"roi_x":4,"roi_y":5,"xsize":2,"ysize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_block_color(global float4* in, global float4* out, int xsize, int ysize, int roi_x, int roi_y, int line_width, int block_count_x) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int cx = roi_x / xsize + gidx;
  int cy = roi_y / ysize + gidy;

  float weight = 1.0f / (xsize * ysize);

  int px = cx * xsize + xsize - roi_x;
  int py = cy * ysize + ysize - roi_y;

  int i, j;
  float4 col = 0.0f;
  for (j = py; j < py + ysize; ++j) {
    for (i = px; i < px + xsize; ++i) {
      col += in[hook(0, j * line_width + i)];
    }
  }
  out[hook(1, gidy * block_count_x + gidx)] = col * weight;
}