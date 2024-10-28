//{"height":3,"output":1,"width":2,"work":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void work2rgba(global int* work, write_only image2d_t output, int width, int height) {
  int2 pos = (int2)(get_global_id(0) + 1, get_global_id(1) + 1);
  if (pos.x > width || pos.y > height)
    return;

  int adr = pos.x + pos.y * (width + 2);
  int idx = work[hook(0, adr)];
  uint4 out_pxl;
  if (idx != 0) {
    int2 idx_pos = (int2)(idx % (width + 2), idx / (width + 2));
    if (idx < 0) {
      out_pxl = (uint4)(0, 20, 255, 255);
    } else {
      out_pxl = (uint4)(((float)idx_pos.x / width) * 255, ((float)idx_pos.y / height) * 255, 0, 255);
    }
  } else {
    out_pxl = (uint4)(0, 0, 0, 255);
  }
  pos = (int2)(pos.x - 1, pos.y - 1);
  barrier(0x02);
  write_imageui(output, pos, out_pxl);
}