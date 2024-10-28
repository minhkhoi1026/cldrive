//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samin = 2 | 0x10;
constant int size = 1;
kernel void erosion(read_only image2d_t src, write_only image2d_t dst) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  for (int i = -size; i <= size; ++i) {
    for (int j = -size; j <= size; ++j) {
      float3 a = read_imagef(src, samin, coords + (int2)(i, j)).xyz * 1000;
      float l = length(a.xy);
      if (l < 1) {
        write_imagef(dst, coords, (float4)(0, 0, 0, 1));
        return;
      }
    }
  }
  write_imagef(dst, coords, read_imagef(src, samin, coords));
}