//{"bias":4,"dst":2,"factor":3,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dog_subtract(read_only image2d_t src1, read_only image2d_t src2, write_only image2d_t dst, float4 factor, float4 bias) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 c1 = read_imagef(src1, coords);
  float4 c2 = read_imagef(src2, coords);
  float4 c = (c1 - c2) * factor + bias;
  write_imagef(dst, coords, clamp(c, 0.0f, 1.0f));
}