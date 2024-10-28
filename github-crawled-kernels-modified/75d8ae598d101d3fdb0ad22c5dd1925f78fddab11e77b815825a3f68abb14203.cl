//{"activity":1,"fg_map":2,"labels":0,"update_map":3,"width":4}
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

kernel void gather_activity(global int* labels, global int* activity, read_only image2d_t fg_map, read_only image2d_t update_map, int width) {
  int2 pos_img = (int2)(get_global_id(0), get_global_id(1));
  int2 pos = (int2)(pos_img.x + 1, pos_img.y + 1);
  uint4 update_pxl = read_imageui(update_map, sampler, pos_img);
  if (update_pxl.s1 != 0) {
    uint4 fg_pxl = read_imageui(fg_map, sampler, pos_img);
    if (fg_pxl.s0 != 0) {
      int adr = pos.x + pos.y * (width + 2);
      int idx = -1 * labels[hook(0, adr)];
      atom_inc(activity + idx);
    }
  }
}