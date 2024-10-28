//{"dest":5,"dest_x":3,"dest_y":4,"src1":2,"src_x":0,"src_y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void copy_image(int src_x, int src_y, read_only image2d_t src1, int dest_x, int dest_y, write_only image2d_t dest) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  int2 src_pos = (int2)(pos.x + src_x, pos.y + src_y);
  int2 dest_pos = (int2)(pos.x + dest_x, pos.y + dest_y);
  uint4 pixel = read_imageui(src1, sampler, src_pos);
  write_imageui(dest, dest_pos, pixel);
}