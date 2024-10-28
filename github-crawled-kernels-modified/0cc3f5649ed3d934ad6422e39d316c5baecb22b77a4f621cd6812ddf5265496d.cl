//{"bg_color":8,"block_count_x":10,"in":0,"norm":9,"out":1,"roi_x":6,"roi_y":7,"xratio":4,"xsize":2,"yratio":5,"ysize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int block_index(int pos, int size) {
  return pos < 0 ? ((pos + 1) / size - 1) : (pos / size);
}

kernel void kernel_pixelize(global float4* in, global float4* out, int xsize, int ysize, float xratio, float yratio, int roi_x, int roi_y, float4 bg_color, int norm, int block_count_x) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  int src_width = get_global_size(0);
  int cx = block_index(gidx + roi_x, xsize) - block_index(roi_x, xsize);
  int cy = block_index(gidy + roi_y, ysize) - block_index(roi_y, ysize);

  float4 grid_color = in[hook(0, cx + cy * block_count_x)];
  float4 out_color = bg_color;

  int x_pos = gidx + roi_x;
  int y_pos = gidy + roi_y;

  int rect_shape_width = ceil(xsize * xratio);
  int rect_shape_height = ceil(ysize * yratio);

  int off_shape_x = floor((xsize - xratio * xsize) / 2.0f);
  int off_shape_y = floor((ysize - yratio * ysize) / 2.0f);

  int start_x = block_index(x_pos, xsize) * xsize - roi_x;
  int start_y = block_index(y_pos, ysize) * ysize - roi_y;

  float shape_area = rect_shape_width * rect_shape_height;

  float center_x = start_x + off_shape_x + (float)(rect_shape_width) / 2.0f;
  float center_y = start_y + off_shape_y + (float)(rect_shape_height) / 2.0f;

  if (norm == 0 && (fabs(gidx - center_x) * rect_shape_height + fabs(gidy - center_y) * rect_shape_width < shape_area))
    out_color = grid_color;

  if (norm == 1 && (((gidx - center_x) / (float)rect_shape_width) * ((gidx - center_x) / (float)rect_shape_width)) + (((gidy - center_y) / (float)rect_shape_height) * ((gidy - center_y) / (float)rect_shape_height)) <= 1.0f)
    out_color = grid_color;

  if (norm == 2 && (gidx >= start_x + off_shape_x && gidy >= start_y + off_shape_y && gidx < start_x + off_shape_x + rect_shape_width && gidy < start_y + off_shape_y + rect_shape_height))
    out_color = grid_color;

  out[hook(1, gidx + gidy * src_width)] = out_color;
}