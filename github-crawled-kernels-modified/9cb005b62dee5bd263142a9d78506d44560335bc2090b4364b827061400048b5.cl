//{"img_input":0,"img_output":1,"transform":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClGrayLevelTransform(read_only image2d_t img_input, write_only image2d_t img_output, constant int* transform) {
  const sampler_t smp = 0 | 4 | 0x10;

  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 pixel = read_imagef(img_input, smp, coords);
  float4 float3 = 0.0f;
  uchar aux = convert_uchar_sat(pixel.x * 255.0f);
  float c = transform[hook(2, aux)] / 255.0f;
  float3.x = c;
  write_imagef(img_output, coords, float3);
}