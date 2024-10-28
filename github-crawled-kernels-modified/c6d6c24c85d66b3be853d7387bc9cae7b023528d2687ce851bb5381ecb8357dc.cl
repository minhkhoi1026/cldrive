//{"binned_heigth":7,"binned_width":6,"image_in":0,"image_out":1,"orig_heigth":5,"orig_width":4,"scale_heigth":3,"scale_width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
;
kernel void bin(const global float* image_in, global float* image_out, const int scale_width, const int scale_heigth, const int orig_width, const int orig_heigth, const int binned_width, const int binned_heigth) {
  int gid0 = get_global_id(0), gid1 = get_global_id(1);

  if ((gid0 < binned_width) && (gid1 < binned_heigth)) {
    int j, i = gid0 + binned_width * gid1;
    float data = 0.0f;
    int w, h, big_h, big_w;
    for (h = gid1 * scale_heigth; h < (gid1 + 1) * scale_heigth; h++) {
      if (h >= orig_heigth) {
        big_h = 2 * orig_heigth - h - 1;
      } else {
        big_h = h;
      }
      for (w = gid0 * scale_width; w < (gid0 + 1) * scale_width; w++) {
        if (w >= orig_width) {
          big_w = 2 * orig_width - w - 1;
        } else {
          big_w = w;
        }
        j = big_h * orig_width + big_w;
        data += image_in[hook(0, j)];
      };
    };
    image_out[hook(1, i)] = data / ((float)(scale_width * scale_heigth));
  };
}