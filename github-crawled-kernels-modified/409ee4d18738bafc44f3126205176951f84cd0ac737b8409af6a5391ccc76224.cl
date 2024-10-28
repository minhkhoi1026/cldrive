//{"gain":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void greyscaleToRGBA(read_only image2d_t input, write_only image2d_t output, float gain) {
  sampler_t s = 0 | 0x10;

  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  if (all(pos < get_image_dim(output))) {
    float v = gain * read_imagef(input, s, pos).s0;
    write_imagef(output, pos, (float4)(v, v, v, 1.0f));
  }
}