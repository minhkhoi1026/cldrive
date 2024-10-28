//{"count":1,"input":2,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void arg_image_to_buffer(global float* output, private const int count, read_only image2d_t input) {
  int w = get_global_id(0);
  int h = get_global_id(1);

  const int offset = (w << 2);

  int2 coord = (int2)(w, h);
  float4 values = read_imagef(input, SAMPLER, coord);
  const int size = count - offset;
  if (size < 4) {
    switch (size) {
      case 3:
        output[hook(0, offset + 2)] = values.s2;
      case 2:
        output[hook(0, offset + 1)] = values.s1;
      case 1:
        output[hook(0, offset)] = values.s0;
    }
  } else {
    vstore4(values, 0, output + offset);
  }
}