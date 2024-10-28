//{"dstImg":1,"height":4,"k":5,"sampler":2,"srcImg":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float k[9] = {1.0f / 16.0f, 2.0f / 16.0f, 1.0f / 16.0f, 2.0f / 16.0f, 4.0f / 16.0f, 2.0f / 16.0f, 1.0f / 16.0f, 2.0f / 16.0f, 1.0f / 16.0f};

kernel void cl_filter(read_only image2d_t srcImg, write_only image2d_t dstImg, sampler_t sampler, int width, int height) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  float4 outClr = (float4)(0.0);

  for (int kIdx = 0; kIdx < 9; kIdx++) {
    int2 kOff = (int2)(kIdx % 3 - 1, kIdx / 3 - 1);

    outClr += read_imagef(srcImg, sampler, pos + kOff) * k[hook(5, kIdx)];
  }

  write_imagef(dstImg, pos, outClr);
}