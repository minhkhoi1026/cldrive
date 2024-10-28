//{"dest":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clMemSetImage(write_only image2d_t dest, float4 value) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  write_imagef(dest, (int2)(x, y), value);
}