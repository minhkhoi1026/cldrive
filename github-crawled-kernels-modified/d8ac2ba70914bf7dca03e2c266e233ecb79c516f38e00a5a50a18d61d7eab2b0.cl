//{"imgA":0,"imgB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x20;
kernel void imgRW(read_only image2d_t imgA, write_only image2d_t imgB) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  uint4 inpixel = read_imageui(imgA, sampler, coords);
  uint4 pixel = (uint4)(0, 0, 0, 255);
  write_imageui(imgB, coords, pixel);
}