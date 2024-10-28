//{"data":0,"result":1,"x":2,"y":3,"z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samp = 0 | 2 | 0x10;
kernel void kernel_main(read_only image3d_t data, global unsigned char* result, unsigned int x, unsigned int y, unsigned int z) {
  int4 coord = (int4)(get_global_id(0), get_global_id(1), get_global_id(2), 1);
  float4 dvalue = read_imagef(data, samp, coord);
  unsigned int index = x * y * coord.z + x * coord.y + coord.x;
  result[hook(1, index)] = dvalue.x * 255.0;
}