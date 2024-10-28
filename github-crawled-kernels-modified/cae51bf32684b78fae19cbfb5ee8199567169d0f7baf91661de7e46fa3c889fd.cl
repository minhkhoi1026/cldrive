//{"fg_map":0,"id":5,"labels":1,"val":6,"width":4,"x":2,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void set_region(write_only image2d_t fg_map, global int* labels, int x, int y, int width, int id, int val) {
  int2 pos = (int2)(get_global_id(0) + x, get_global_id(1) + y);
  int adr = pos.x + pos.y * (width + 2);
  int px_id = -1 * labels[hook(1, adr)];
  if (px_id == id) {
    uint4 out_pxl = (uint4)(val, val, val, 255);
    int2 wpos = (int2)(pos.x - 1, pos.y - 1);
    write_imageui(fg_map, wpos, out_pxl);
  }
}