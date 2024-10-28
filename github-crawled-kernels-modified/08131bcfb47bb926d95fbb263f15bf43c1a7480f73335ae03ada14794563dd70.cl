//{"data":0,"result":1,"rvalue":5,"x":2,"y":3,"z":4}
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
  float rvalue[3 * 3 * 3];
  int id = 0;
  int c;
  float temp;
  int i, j, k;
  for (i = 0; i < 3; ++i)
    for (j = 0; j < 3; ++j)
      for (k = 0; k < 3; ++k) {
        kc = (int4)(coord.x + (i - 3 / 2), coord.y + (j - 3 / 2), coord.z + (k - 3 / 2), 1);
        dvalue = read_imagef(data, samp, kc);
        rvalue[hook(5, id)] = dvalue.x;
        if (id > 0) {
          c = id;
          while (c > 0) {
            if (rvalue[hook(5, c)] < rvalue[hook(5, c - 1)]) {
              temp = rvalue[hook(5, c)];
              rvalue[hook(5, c)] = rvalue[hook(5, c - 1)];
              rvalue[hook(5, c - 1)] = temp;
            } else
              break;
            c--;
          }
        }
        id++;
      }
  unsigned int index = x * y * coord.z + x * coord.y + coord.x;
  result[hook(1, index)] = rvalue[hook(5, 3 * 3 * 3 / 2 - 1)] * 255.0;
}