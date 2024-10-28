//{"activity_ratio":4,"alpha":6,"current":1,"input":0,"labels":3,"output":2,"threshold":5,"width":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
int read_val(read_only image2d_t input, int x, int y) {
  int2 pos = (int2)(x, y);
  uint4 pixel = read_imageui(input, sampler, pos);
  return pixel.s0;
}

kernel void refresh_decay(read_only image2d_t input, write_only image2d_t current, write_only image2d_t output, global int* labels, global float* activity_ratio, float threshold, int alpha, int width) {
  int2 pos_img = (int2)(get_global_id(0), get_global_id(1));
  int2 pos = (int2)(pos_img.x + 1, pos_img.y + 1);

  uint4 in_pxl = read_imageui(input, sampler, pos_img);
  int val = in_pxl.s0;
  if (val != 0) {
    int adr = pos.x + pos.y * (width + 2);
    int id = -1 * labels[hook(3, adr)];
    if (id > 0 && activity_ratio[hook(4, id)] > threshold) {
      val = 255;
    } else {
      val = in_pxl.s0 - ((1 - activity_ratio[hook(4, id)]) * alpha);
      if (val < 0) {
        val = 0;
      }
    }
  }
  barrier(0x02);
  uint4 out_pxl = (uint4)(val, val, val, 255);
  write_imageui(current, pos_img, out_pxl);
  write_imageui(output, pos_img, out_pxl);
}