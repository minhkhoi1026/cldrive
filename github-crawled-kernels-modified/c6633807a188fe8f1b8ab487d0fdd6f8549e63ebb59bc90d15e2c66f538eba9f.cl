//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void sobel_y(read_only image2d_t src, write_only image2d_t dst) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 c1 = read_imagef(src, sampler, coords - (int2)(0, 1));
  float4 c2 = read_imagef(src, sampler, coords + (int2)(0, 1));
  write_imagef(dst, coords, fabs(c1 - c2));
}