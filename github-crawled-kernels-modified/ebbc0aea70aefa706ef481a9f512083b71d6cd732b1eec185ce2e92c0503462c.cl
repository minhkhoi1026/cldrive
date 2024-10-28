//{"data":0,"result":1,"x":2,"y":3,"z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float gauss(int i, int j, int k) {
  float s = 10;
  float r = i * i + j * j + k * k;
  return exp(-r / s) / pow(3.1415 * s, 1.5);
}
const sampler_t samp = 0 | 2 | 0x10;
kernel void kernel_main(read_only image3d_t data, global unsigned char* result, unsigned int x, unsigned int y, unsigned int z) {
  int4 coord = (int4)(get_global_id(0), get_global_id(1), get_global_id(2), 1);
  int4 kc;
  float4 dvalue;
  float rvalue = 0.0;
  for (int i = 0; i < 3; ++i)
    for (int j = 0; j < 3; ++j)
      for (int k = 0; k < 3; ++k) {
        kc = (int4)(coord.x + (i - 3 / 2), coord.y + (j - 3 / 2), coord.z + (k - 3 / 2), 1);
        dvalue = read_imagef(data, samp, kc);
        rvalue += gauss(i - 3 / 2, j - 3 / 2, k - 3 / 2) * dvalue.x;
      }
  unsigned int index = x * y * coord.z + x * coord.y + coord.x;
  result[hook(1, index)] = rvalue * 255.0;
}