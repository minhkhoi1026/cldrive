//{"dst":1,"float3":2,"src":0,"xy":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10;
kernel void pad(read_only image2d_t src, write_only image2d_t dst, float4 float3, int2 xy) {
  int2 size_src = get_image_dim(src);
  int2 loc = (int2)(get_global_id(0), get_global_id(1));
  int2 src_pos = (int2)(get_global_id(0) - xy.x, get_global_id(1) - xy.y);
  float4 pixel = loc.x >= size_src.x + xy.x || loc.y >= size_src.y + xy.y || loc.x < xy.x || loc.y < xy.y ? float3 : read_imagef(src, sampler, src_pos);
  write_imagef(dst, loc, pixel);
}