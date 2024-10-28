//{"height":4,"input":0,"sizes":2,"width":3,"work":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void assign_indices(read_only image2d_t input, global int* work, global int* sizes, int width, int height) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  int2 pos_img = (int2)(pos.x - 1, pos.y - 1);
  if (pos.x >= width + 2 || pos.y >= height + 2)
    return;

  int val = 0;
  int size = 0;
  int idx = pos.x + (pos.y * (width + 2));

  if (pos.x > 0 && pos.x <= width && pos.y > 0 && pos.y <= height) {
    uint4 pxl = read_imageui(input, sampler, pos_img);
    if (pxl.x != 0) {
      val = idx;
      size = 1;
    }
  }

  barrier(0x02);
  work[hook(1, idx)] = val;
  sizes[hook(2, idx)] = size;
}