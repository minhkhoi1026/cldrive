//{"dst":1,"float3":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clear(float4 float3, write_only image2d_t dst) {
  unsigned int gid_x = get_global_id(0);
  unsigned int gid_y = get_global_id(1);

  write_imagef(dst, (int2)(gid_x, gid_y), float3);
}