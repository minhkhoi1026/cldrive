//{"input":0,"output":1,"pixel_in":3,"pixel_out":4,"table":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_gamma(read_only image2d_t input, write_only image2d_t output, global float* table) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 0 | 0x10;
  float4 pixel_in[8], pixel_out[8];
  int i = 0, j = 0;

  for (j = 0; j < 2; j++) {
    for (i = 0; i < 4; i++) {
      pixel_in[hook(3, j * 4 + i)] = read_imagef(input, sampler, (int2)(4 * x + i, 2 * y + j));
      pixel_out[hook(4, j * 4 + i)].x = table[hook(2, convert_int(pixel_in[hook(3, j * 4 + i)].x * 255.))] / 255.0;
      pixel_out[hook(4, j * 4 + i)].y = table[hook(2, convert_int(pixel_in[hook(3, j * 4 + i)].y * 255.))] / 255.0;
      pixel_out[hook(4, j * 4 + i)].z = table[hook(2, convert_int(pixel_in[hook(3, j * 4 + i)].z * 255.))] / 255.0;
      pixel_out[hook(4, j * 4 + i)].w = 0.0;
      write_imagef(output, (int2)(4 * x + i, 2 * y + j), pixel_out[hook(4, j * 4 + i)]);
    }
  }
}