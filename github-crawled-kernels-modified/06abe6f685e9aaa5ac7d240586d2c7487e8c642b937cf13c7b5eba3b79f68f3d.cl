//{"input_image":1,"mask":2,"output_image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gauss9x9_cols(write_only image2d_t output_image, read_only image2d_t input_image) {
  float mask[9] = {
      01.f / 256.f, 08.f / 256.f, 28.f / 256.f, 56.f / 256.f, 70.f / 256.f, 56.f / 256.f, 28.f / 256.f, 08.f / 256.f, 01.f / 256.f,
  };

  const sampler_t sampler = 0x10 | 0 | 2;

  int2 outcoord = (int2)(get_global_id(0), get_global_id(1));
  float2 incoord = (float2)((float)get_global_id(0), (float)get_global_id(1));

  float4 c = 0.f;

  if (outcoord.x >= get_image_width(output_image) || outcoord.y >= get_image_height(output_image)) {
    return;
  }

  c += read_imagef(input_image, sampler, incoord + (float2)(0.f, -4.f)) * mask[hook(2, 0)];
  c += read_imagef(input_image, sampler, incoord + (float2)(0.f, -3.f)) * mask[hook(2, 1)];
  c += read_imagef(input_image, sampler, incoord + (float2)(0.f, -2.f)) * mask[hook(2, 2)];
  c += read_imagef(input_image, sampler, incoord + (float2)(0.f, -1.f)) * mask[hook(2, 3)];
  c += read_imagef(input_image, sampler, incoord + (float2)(0.f, +0.f)) * mask[hook(2, 4)];
  c += read_imagef(input_image, sampler, incoord + (float2)(0.f, +1.f)) * mask[hook(2, 5)];
  c += read_imagef(input_image, sampler, incoord + (float2)(0.f, +2.f)) * mask[hook(2, 6)];
  c += read_imagef(input_image, sampler, incoord + (float2)(0.f, +3.f)) * mask[hook(2, 7)];
  c += read_imagef(input_image, sampler, incoord + (float2)(0.f, +4.f)) * mask[hook(2, 8)];

  barrier(0x01);

  write_imagef(output_image, outcoord, c);
}