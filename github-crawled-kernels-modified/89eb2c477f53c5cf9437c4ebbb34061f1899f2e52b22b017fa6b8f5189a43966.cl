//{"dst":0,"fieldSpeed":2,"fieldSpeed0":3,"mask":4,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ink_step(write_only image2d_t dst, read_only image2d_t src, global float4* fieldSpeed, global float4* fieldSpeed0) {
  unsigned int gid_x = get_global_id(0);
  unsigned int gid_y = get_global_id(1);
  float4 c = (float4)(0, 0, 0, 0);

  if (gid_x == 0 || gid_y == 0 || gid_x == 1278 || gid_y == 718) {
    c = read_imagef(src, (int2)(gid_x, gid_y)) * 0.8f;
    write_imagef(dst, (int2)(gid_x, gid_y), c);
    return;
  }

  float mask[9] = {0.00f, 0.00f, 0.00f, 0.00f, 0.25f, 0.00f, 0.25f, 0.25f, 0.25f};

  unsigned int x = gid_x - 1;
  unsigned int y = gid_y - 1;

  for (unsigned int j = 0; j < 3; ++j) {
    for (unsigned int i = 0; i < 3; ++i) {
      c += read_imagef(src, (int2)(x + i, y + j)) * mask[hook(4, j * 3 + i)];
    }
  }
  c.w = 1.0f;
  write_imagef(dst, (int2)(gid_x, gid_y), c);
}