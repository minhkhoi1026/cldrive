//{"img_input1":0,"img_input2":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglCl3dBinEqual(read_only image3d_t img_input1, read_only image3d_t img_input2, global char* output) {
  if (output[hook(2, 0)] == 1)
    return;

  int4 coords = (int4)(get_global_id(0), get_global_id(1), get_global_id(2), 0);
  const sampler_t smp = 0 | 4 | 0x10;
  float4 p1 = read_imagef(img_input1, smp, coords);
  float4 p2 = read_imagef(img_input2, smp, coords);
  if (!(p1.x == p2.x)) {
    output[hook(2, 0)] = 1;
  }
  if (!(p1.y == p2.y)) {
    output[hook(2, 0)] = 1;
  }
  if (!(p1.z == p2.z)) {
    output[hook(2, 0)] = 1;
  }
  if (!(p1.w == p2.w)) {
    output[hook(2, 0)] = 1;
  }
}