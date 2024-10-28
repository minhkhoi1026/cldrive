//{"data":0,"result":1,"x":2,"y":3,"z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samp = 0 | 2 | 0x10;
kernel void kernel_main(read_only image3d_t data, global unsigned char* result, unsigned int x, unsigned int y, unsigned int z) {
  int4 coord = (int4)(get_global_id(0), get_global_id(1), get_global_id(2), 1);
  int4 kc;
  float4 dvalue;
  float rvalue = 0.0;
  int i, j, k;
  dvalue = read_imagef(data, samp, coord);
  float cvalue = dvalue.x;
  for (i = 0; i < 3; ++i)
    for (j = 0; j < 3; ++j)
      for (k = 0; k < 3; ++k) {
        kc = (int4)(coord.x + (i - 3 / 2), coord.y + (j - 3 / 2), coord.z + (k - 3 / 2), 1);
        dvalue = read_imagef(data, samp, kc);
        rvalue += fabs(dvalue.x - cvalue);
      }
  unsigned int index = x * y * coord.z + x * coord.y + coord.x;
  rvalue /= 3 * 3 * 3;
  if (rvalue > 0.03)
    rvalue = 1.0;
  else {
    rvalue -= 0.03;
    rvalue *= rvalue;
    rvalue = -rvalue / 0.01;
    rvalue = exp(rvalue);
  }
  result[hook(1, index)] = clamp(cvalue * rvalue, 0.0f, 1.0f) * 255.0;
}