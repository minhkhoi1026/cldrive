//{"img_input1":0,"img_input2":1,"img_output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClSub(read_only image2d_t img_input1, read_only image2d_t img_input2, write_only image2d_t img_output) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 4 | 0x10;
  float4 p1 = read_imagef(img_input1, smp, coords);
  float4 p2 = read_imagef(img_input2, smp, coords);

  float4 minus;
  minus.x = max(p1.x - p2.x, 0.0f);
  minus.y = max(p1.y - p2.y, 0.0f);
  minus.z = max(p1.z - p2.z, 0.0f);
  minus.w = max(p1.w - p2.w, 0.0f);
  write_imagef(img_output, coords, minus);
}