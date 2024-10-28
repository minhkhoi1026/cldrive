//{"hx":3,"hy":4,"img_out":0,"u":1,"v":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samplerA = 0 | 4 | 0x10;
const sampler_t samplerB = 1 | 6 | 0x20;
kernel void project1(write_only image2d_t img_out, read_only image2d_t u, read_only image2d_t v, float hx, float hy) {
  const int xpos = get_global_id(0);
  const int ypos = get_global_id(1);

  float dl = read_imagef(u, samplerA, (int2)(xpos - 1, ypos)).x;
  float dr = read_imagef(u, samplerA, (int2)(xpos + 1, ypos)).x;
  float du = read_imagef(v, samplerA, (int2)(xpos, ypos - 1)).x;
  float dd = read_imagef(v, samplerA, (int2)(xpos, ypos + 1)).x;

  float value = -0.5f * (hx * (dr - dl) + hy * (dd - du));

  write_imagef(img_out, (int2)(xpos, ypos), (float4)(value, 0, 0, 0));
}