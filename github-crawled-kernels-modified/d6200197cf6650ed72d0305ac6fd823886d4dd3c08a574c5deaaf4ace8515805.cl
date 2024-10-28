//{"dst":0,"float3":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ink_drop(write_only image2d_t dst, read_only image2d_t src, float4 float3) {
  unsigned int gid_x = get_global_id(0);
  unsigned int gid_y = get_global_id(1);

  float4 c = read_imagef(src, (int2)(gid_x, gid_y));
  c += float3;
  write_imagef(dst, (int2)(gid_x, gid_y), c);
}