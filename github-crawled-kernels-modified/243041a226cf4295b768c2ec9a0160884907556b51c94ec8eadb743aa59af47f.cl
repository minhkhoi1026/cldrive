//{"bbox":6,"block_count_x":8,"in":0,"line_width":7,"out":1,"roi_x":4,"roi_y":5,"xsize":2,"ysize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int block_index(int pos, int size) {
  return pos < 0 ? ((pos + 1) / size - 1) : (pos / size);
}

kernel void calc_block_color(global float4* in, global float4* out, int xsize, int ysize, int roi_x, int roi_y, int4 bbox, int line_width, int block_count_x) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  int cx = block_index(roi_x, xsize) + gidx;
  int cy = block_index(roi_y, ysize) + gidy;

  int px0 = max(bbox.s0, cx * xsize) - roi_x + xsize;
  int py0 = max(bbox.s1, cy * ysize) - roi_y + ysize;

  int px1 = min(bbox.s2, cx * xsize + xsize) - roi_x + xsize;
  int py1 = min(bbox.s3, cy * ysize + ysize) - roi_y + ysize;

  int i, j;

  float4 col = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  int real_xsize = px1 - px0;
  int real_ysize = py1 - py0;

  float weight = 1.0f / (real_xsize * real_ysize);

  for (j = py0; j < py1; ++j) {
    for (i = px0; i < px1; ++i) {
      col += in[hook(0, j * line_width + i)];
    }
  }
  out[hook(1, gidy * block_count_x + gidx)] = col * weight;
}