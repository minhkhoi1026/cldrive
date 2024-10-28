//{"dstImg":1,"height":4,"k":5,"sampler":2,"srcImg":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float k[9] = {1.0f / 16.0f, 2.0f / 16.0f, 1.0f / 16.0f, 2.0f / 16.0f, 4.0f / 16.0f, 2.0f / 16.0f, 1.0f / 16.0f, 2.0f / 16.0f, 1.0f / 16.0f};

kernel void cl_filter(read_only image2d_t srcImg, write_only image2d_t dstImg, sampler_t sampler, int width, int height) {
  int2 p = (int2)(get_global_id(0), get_global_id(1));

  float4 p00 = read_imagef(srcImg, sampler, p + (int2)(-1, -1)) * k[hook(5, 0)];
  float4 p01 = read_imagef(srcImg, sampler, p + (int2)(0, -1)) * k[hook(5, 1)];
  float4 p02 = read_imagef(srcImg, sampler, p + (int2)(1, -1)) * k[hook(5, 2)];
  float4 p10 = read_imagef(srcImg, sampler, p + (int2)(-1, 0)) * k[hook(5, 3)];
  float4 p11 = read_imagef(srcImg, sampler, p) * k[hook(5, 4)];
  float4 p12 = read_imagef(srcImg, sampler, p + (int2)(1, 0)) * k[hook(5, 5)];
  float4 p20 = read_imagef(srcImg, sampler, p + (int2)(-1, 1)) * k[hook(5, 6)];
  float4 p21 = read_imagef(srcImg, sampler, p + (int2)(0, 1)) * k[hook(5, 7)];
  float4 p22 = read_imagef(srcImg, sampler, p + (int2)(1, 1)) * k[hook(5, 8)];

  float4 outClr = p00 + p01 + p02 + p10 + p11 + p12 + p20 + p21 + p22;
  write_imagef(dstImg, p, outClr);
}