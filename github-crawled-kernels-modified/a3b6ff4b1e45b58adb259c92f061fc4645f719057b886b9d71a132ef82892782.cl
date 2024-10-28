//{"origImgL":0,"origImgR":1,"resImgL":2,"resImgR":3,"scale_h":5,"scale_w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t tmp = 0 | 2 | 0x10;
kernel void resize(read_only image2d_t origImgL, read_only image2d_t origImgR, global uchar* resImgL, global uchar* resImgR, int scale_w, int scale_h) {
  const int i = get_global_id(0);
  const int j = get_global_id(1);

  int2 redIdx = {(4 * j - 1 * (j > 0)), (4 * i - 1 * (i > 0))};

  uint4 pixelLeftImage = read_imageui(origImgL, tmp, redIdx);
  uint4 pixelRightImage = read_imageui(origImgR, tmp, redIdx);

  resImgL[hook(2, i * scale_w + j)] = 0.2126 * pixelLeftImage.x + 0.7152 * pixelLeftImage.y + 0.0722 * pixelLeftImage.z;
  resImgR[hook(3, i * scale_w + j)] = 0.2126 * pixelRightImage.x + 0.7152 * pixelRightImage.y + 0.0722 * pixelRightImage.z;
}