//{"height":3,"input":0,"uOutput":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void copy_buffer_to_image2d(global const float4* input, write_only image2d_t uOutput, private const int width, private const int height) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x < width && y < height) {
    write_imagef(uOutput, (int2)(x, y), input[hook(0, x + y * width)]);
  }
}