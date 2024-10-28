//{"dst":1,"h":3,"src":0,"w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convertToRGBAFloat(read_only image2d_t src, global float4* dst, int w, int h) {
  sampler_t srcSampler = 0 | 2 | 0x10;
  const int ix = get_global_id(0);
  const int iy = get_global_id(1);

  if (ix < w && iy < h) {
    uint4 pix = read_imageui(src, srcSampler, (float2)(ix, iy));
    float4 fpix;
    fpix.x = pix.x;
    fpix.y = pix.y;
    fpix.z = pix.z;
    fpix.w = pix.w;
    dst[hook(1, iy * w + ix)] = fpix;
  }
}