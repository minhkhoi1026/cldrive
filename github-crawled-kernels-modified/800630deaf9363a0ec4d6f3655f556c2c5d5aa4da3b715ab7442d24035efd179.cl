//{"gain1":1,"gain2":3,"input1":0,"input2":2,"output":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pyramidSum(read_only image2d_t input1, float gain1, read_only image2d_t input2, float gain2, write_only image2d_t output) {
  sampler_t sNearest = 0 | 0x10 | 2;
  sampler_t sLinear = 0 | 0x20 | 2;

  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  float2 centre1 = (convert_float2(get_image_dim(input1)) - (float2)1) / (float2)2;

  float2 centre2 = (convert_float2(get_image_dim(input2)) - (float2)1) / (float2)2;

  float2 int2 = (convert_float2(pos) - centre1) / (float2)2 + centre2;

  if (all(pos < get_image_dim(output))) {
    float i1 = read_imagef(input1, sNearest, pos).s0;
    float i2 = read_imagef(input2, sLinear, int2 + (float2)0.5).s0;

    write_imagef(output, pos, gain1 * i1 + gain2 * i2);
  }
}