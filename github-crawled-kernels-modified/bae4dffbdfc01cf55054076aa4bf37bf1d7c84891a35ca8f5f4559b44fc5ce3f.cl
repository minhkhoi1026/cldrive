//{"result":2,"srcA":0,"srcB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void image_and(read_only image2d_t srcA, read_only image2d_t srcB, write_only image2d_t result) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  uint4 pxlA = read_imageui(srcA, sampler, pos);
  uint4 pxlB = read_imageui(srcB, sampler, pos);
  uint4 pxlR = (uint4)(0, 0, 0, 255);
  if (pxlA.s0 > 0 && pxlB.s0 > 0) {
    pxlR = (uint4)(255, 255, 255, 255);
  }
  barrier(0x02);
  write_imageui(result, pos, pxlR);
}