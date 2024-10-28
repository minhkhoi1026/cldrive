//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void process(read_only image2d_t src, write_only image2d_t dst) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float4 float3;

  float3 = read_imagef(src, sampler, (int2)(x, y));
  float gray = (float3.x + float3.y + float3.z) / 3;
  write_imagef(dst, (int2)(x, y), (float4)(gray, gray, gray, 0));
}