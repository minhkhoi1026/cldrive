//{"dstImg":1,"height":4,"kernelWeights":5,"sampler":2,"srcImg":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void smooth_more_filter(read_only image2d_t srcImg, write_only image2d_t dstImg, sampler_t sampler, int width, int height) {
  int4 kernelWeights[25] = {1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 1, 5, 44, 5, 1, 1, 5, 5, 5, 1, 1, 1, 1, 1, 1};
  int scale = 100;
  int offset = 0;
  int2 outImageCoord = (int2)(get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height) {
    int4 outColor = (int4)(0, 0, 0, 0);
    outColor = ((read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 2, outImageCoord.y - 2)) * kernelWeights[hook(5, 0)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 1, outImageCoord.y - 2)) * kernelWeights[hook(5, 1)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x, outImageCoord.y - 2)) * kernelWeights[hook(5, 2)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 1, outImageCoord.y - 2)) * kernelWeights[hook(5, 3)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 2, outImageCoord.y - 2)) * kernelWeights[hook(5, 4)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 2, outImageCoord.y - 1)) * kernelWeights[hook(5, 5)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 1, outImageCoord.y - 1)) * kernelWeights[hook(5, 6)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x, outImageCoord.y - 1)) * kernelWeights[hook(5, 7)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 1, outImageCoord.y - 1)) * kernelWeights[hook(5, 8)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 2, outImageCoord.y - 1)) * kernelWeights[hook(5, 9)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 2, outImageCoord.y)) * kernelWeights[hook(5, 10)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 1, outImageCoord.y)) * kernelWeights[hook(5, 11)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x, outImageCoord.y)) * kernelWeights[hook(5, 12)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 1, outImageCoord.y)) * kernelWeights[hook(5, 13)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 2, outImageCoord.y)) * kernelWeights[hook(5, 14)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 2, outImageCoord.y + 1)) * kernelWeights[hook(5, 15)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 1, outImageCoord.y + 1)) * kernelWeights[hook(5, 16)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x, outImageCoord.y + 1)) * kernelWeights[hook(5, 17)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 1, outImageCoord.y + 1)) * kernelWeights[hook(5, 18)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 2, outImageCoord.y + 1)) * kernelWeights[hook(5, 19)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 2, outImageCoord.y + 2)) * kernelWeights[hook(5, 20)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x - 1, outImageCoord.y + 2)) * kernelWeights[hook(5, 21)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x, outImageCoord.y + 2)) * kernelWeights[hook(5, 22)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 1, outImageCoord.y + 2)) * kernelWeights[hook(5, 23)]) + (read_imagei(srcImg, sampler, (int2)(outImageCoord.x + 2, outImageCoord.y + 2)) * kernelWeights[hook(5, 24)])) / scale;
    outColor = outColor + offset;

    write_imagei(dstImg, outImageCoord, outColor);
  }
}