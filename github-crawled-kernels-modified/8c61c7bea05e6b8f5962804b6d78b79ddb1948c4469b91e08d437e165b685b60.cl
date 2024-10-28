//{"input_image":1,"mask":3,"mask[0]":2,"mask[1]":4,"mask[2]":5,"mask[3]":6,"mask[4]":7,"output_image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void downsampledgauss5x5_cols(write_only image2d_t output_image, read_only image2d_t input_image) {
  float mask[5][5] = {01.f / 256.f, 04.f / 256.f, 06.f / 256.f, 04.f / 256.f, 01.f / 256.f, 04.f / 256.f, 16.f / 256.f, 24.f / 256.f, 16.f / 256.f, 04.f / 256.f, 06.f / 256.f, 24.f / 256.f, 36.f / 256.f, 24.f / 256.f, 06.f / 256.f, 04.f / 256.f, 16.f / 256.f, 24.f / 256.f, 16.f / 256.f, 04.f / 256.f, 01.f / 256.f, 04.f / 256.f, 06.f / 256.f, 04.f / 256.f, 01.f / 256.f};

  const sampler_t sampler = 0x10 | 0 | 2;

  int2 outcoord = (int2)(get_global_id(0), get_global_id(1));

  float2 incoord = (float2)((float)(2 * get_global_id(0) + (get_global_id(1) & 0x1)), (float)get_global_id(1));

  float4 c = 0.f;

  if (outcoord.x >= get_image_width(output_image) || outcoord.y >= get_image_height(output_image)) {
    return;
  }

  c += read_imagef(input_image, sampler, incoord + (float2)(+0.0f, -4.0f)) * mask[hook(3, 0)][hook(2, 0)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+1.0f, -3.0f)) * mask[hook(3, 1)][hook(4, 0)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+2.0f, -2.0f)) * mask[hook(3, 2)][hook(5, 0)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+3.0f, -1.0f)) * mask[hook(3, 3)][hook(6, 0)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+4.0f, +0.0f)) * mask[hook(3, 4)][hook(7, 0)];
  c += read_imagef(input_image, sampler, incoord + (float2)(-1.0f, -3.0f)) * mask[hook(3, 0)][hook(2, 1)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+0.0f, -2.0f)) * mask[hook(3, 1)][hook(4, 1)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+1.0f, -1.0f)) * mask[hook(3, 2)][hook(5, 1)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+2.0f, +0.0f)) * mask[hook(3, 3)][hook(6, 1)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+3.0f, +1.0f)) * mask[hook(3, 4)][hook(7, 1)];
  c += read_imagef(input_image, sampler, incoord + (float2)(-2.0f, -2.0f)) * mask[hook(3, 0)][hook(2, 2)];
  c += read_imagef(input_image, sampler, incoord + (float2)(-1.0f, -1.0f)) * mask[hook(3, 1)][hook(4, 2)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+0.0f, +0.0f)) * mask[hook(3, 2)][hook(5, 2)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+1.0f, +1.0f)) * mask[hook(3, 3)][hook(6, 2)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+2.0f, +2.0f)) * mask[hook(3, 4)][hook(7, 2)];
  c += read_imagef(input_image, sampler, incoord + (float2)(-3.0f, -1.0f)) * mask[hook(3, 0)][hook(2, 3)];
  c += read_imagef(input_image, sampler, incoord + (float2)(-2.0f, +0.0f)) * mask[hook(3, 1)][hook(4, 3)];
  c += read_imagef(input_image, sampler, incoord + (float2)(-1.0f, +1.0f)) * mask[hook(3, 2)][hook(5, 3)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+0.0f, +2.0f)) * mask[hook(3, 3)][hook(6, 3)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+1.0f, +3.0f)) * mask[hook(3, 4)][hook(7, 3)];
  c += read_imagef(input_image, sampler, incoord + (float2)(-4.0f, +0.0f)) * mask[hook(3, 0)][hook(2, 4)];
  c += read_imagef(input_image, sampler, incoord + (float2)(-3.0f, +1.0f)) * mask[hook(3, 1)][hook(4, 4)];
  c += read_imagef(input_image, sampler, incoord + (float2)(-2.0f, +2.0f)) * mask[hook(3, 2)][hook(5, 4)];
  c += read_imagef(input_image, sampler, incoord + (float2)(-1.0f, +3.0f)) * mask[hook(3, 3)][hook(6, 4)];
  c += read_imagef(input_image, sampler, incoord + (float2)(+0.0f, +4.0f)) * mask[hook(3, 4)][hook(7, 4)];

  write_imagef(output_image, outcoord, c);
}