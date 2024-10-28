//{"D2xptr":6,"D2yptr":9,"Dxptr":0,"Dxyptr":12,"Dyptr":3,"d2x_offset":8,"d2x_step":7,"d2y_offset":11,"d2y_step":10,"dst":21,"dst_cols":19,"dst_offset":17,"dst_rows":18,"dst_step":16,"dstptr":15,"dx_offset":2,"dx_step":1,"dxy_offset":14,"dxy_step":13,"dy_offset":5,"dy_step":4,"factor":20}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void preCornerDetect(global const uchar* Dxptr, int dx_step, int dx_offset, global const uchar* Dyptr, int dy_step, int dy_offset, global const uchar* D2xptr, int d2x_step, int d2x_offset, global const uchar* D2yptr, int d2y_step, int d2y_offset, global const uchar* Dxyptr, int dxy_step, int dxy_offset, global uchar* dstptr, int dst_step, int dst_offset, int dst_rows, int dst_cols, float factor) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < dst_cols && y < dst_rows) {
    int dx_index = mad24(dx_step, y, (int)sizeof(float) * x + dx_offset);
    int dy_index = mad24(dy_step, y, (int)sizeof(float) * x + dy_offset);
    int d2x_index = mad24(d2x_step, y, (int)sizeof(float) * x + d2x_offset);
    int d2y_index = mad24(d2y_step, y, (int)sizeof(float) * x + d2y_offset);
    int dxy_index = mad24(dxy_step, y, (int)sizeof(float) * x + dxy_offset);
    int dst_index = mad24(dst_step, y, (int)sizeof(float) * x + dst_offset);

    float dx = *(global const float*)(Dxptr + dx_index);
    float dy = *(global const float*)(Dyptr + dy_index);
    float d2x = *(global const float*)(D2xptr + d2x_index);
    float d2y = *(global const float*)(D2yptr + d2y_index);
    float dxy = *(global const float*)(Dxyptr + dxy_index);
    global float* dst = (global float*)(dstptr + dst_index);

    dst[hook(21, 0)] = factor * (dx * dx * d2y + dy * dy * d2x - 2 * dx * dy * dxy);
  }
}