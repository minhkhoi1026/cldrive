//{"height":4,"img_in":0,"u":1,"v":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samplerA = 0 | 4 | 0x10;
const sampler_t samplerB = 1 | 6 | 0x20;
kernel void project2(read_only image2d_t img_in, global float* u, global float* v, int width, int height) {
  const int xpos = get_global_id(0);
  const int ypos = get_global_id(1);

  float dr = read_imagef(img_in, samplerA, (int2)(xpos + 1, ypos)).x;
  float dl = read_imagef(img_in, samplerA, (int2)(xpos - 1, ypos)).x;
  float dd = read_imagef(img_in, samplerA, (int2)(xpos, ypos + 1)).x;
  float du = read_imagef(img_in, samplerA, (int2)(xpos, ypos - 1)).x;

  float u_val = 0.5f * (dr - dl) * width;
  float v_val = 0.5f * (dd - du) * height;
  u[hook(1, xpos + width * ypos)] -= u_val;
  v[hook(2, xpos + width * ypos)] -= v_val;
}