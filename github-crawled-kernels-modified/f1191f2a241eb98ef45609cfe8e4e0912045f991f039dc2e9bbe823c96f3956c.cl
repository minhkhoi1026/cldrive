//{"clip_val":12,"cos_theta":11,"dst_data":1,"dst_dx":8,"dst_dy":9,"dst_ht":7,"dst_wd":6,"ht":5,"rotctr_x":2,"rotctr_y":3,"sin_theta":10,"src_data":0,"wd":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_rotate_float64(global double* src_data, global double* dst_data, int rotctr_x, int rotctr_y, int wd, int ht, int dst_wd, int dst_ht, int dst_dx, int dst_dy, double sin_theta, double cos_theta, double clip_val) {
  const int iy = get_global_id(0);
  const int ix = get_global_id(1);

  int xi = ix - dst_dx - rotctr_x;
  int yi = iy - dst_dy - rotctr_y;

  double xpos = (((double)xi) * cos_theta - ((double)yi) * sin_theta) + rotctr_x;
  double ypos = (((double)xi) * sin_theta + ((double)yi) * cos_theta) + rotctr_y;

  int xp = (int)round(xpos);
  int yp = (int)round(ypos);

  if (((xp >= 0) && (xp < wd)) && ((yp >= 0) && (yp < ht))) {
    dst_data[hook(1, iy * dst_wd + ix)] = src_data[hook(0, yp * wd + xp)];
  } else {
    dst_data[hook(1, iy * dst_wd + ix)] = clip_val;
  }
}