//{"dstImg":1,"height":4,"kernelWeights":5,"sampler":2,"srcImg":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void edge_enhance_filter(read_only image2d_t srcImg, write_only image2d_t dstImg, sampler_t sampler, int width, int height) {
  int4 kernelWeights[9] = {-1, -1, -1, -1, 10, -1, -1, -1, -1};
  int scale = 2;
  int offset = 0;
  int2 outImageCoord = (int2)(get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height) {
    int4 outColor = (int4)(0, 0, 0, 0);
    outColor = ((read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 1, outImageCoord.y - 1)) * kernelWeights[hook(5, 0)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x, outImageCoord.y - 1)) * kernelWeights[hook(5, 1)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 1, outImageCoord.y - 1)) * kernelWeights[hook(5, 2)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 1, outImageCoord.y)) * kernelWeights[hook(5, 3)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x, outImageCoord.y)) * kernelWeights[hook(5, 4)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 1, outImageCoord.y)) * kernelWeights[hook(5, 5)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 1, outImageCoord.y + 1)) * kernelWeights[hook(5, 6)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x, outImageCoord.y + 1)) * kernelWeights[hook(5, 7)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 1, outImageCoord.y + 1)) * kernelWeights[hook(5, 8)])) / scale;
    outColor = outColor + offset;

    write_imagei(dstImg, outImageCoord, outColor);
  }
}