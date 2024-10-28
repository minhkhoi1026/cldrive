//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void runtime_use_host_ptr_image(read_only image2d_t src, write_only image2d_t dst) {
  const sampler_t sampler = 0 | 0 | 0x10;
  int2 coord;
  coord.x = (int)get_global_id(0);
  coord.y = (int)get_global_id(1);
  float4 data = read_imagef(src, sampler, coord);
  write_imagef(dst, coord, data);
}