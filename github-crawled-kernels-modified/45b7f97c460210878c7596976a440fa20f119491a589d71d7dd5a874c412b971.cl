//{"imgA":0,"imgB":1,"sampler":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void imgRW(read_only image2d_t imgA, write_only image2d_t imgB, sampler_t sampler) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 pixel = read_imagef(imgA, sampler, coords);
  write_imagef(imgB, coords, (float4)(pixel.z, pixel.y, pixel.x, pixel.w));
}