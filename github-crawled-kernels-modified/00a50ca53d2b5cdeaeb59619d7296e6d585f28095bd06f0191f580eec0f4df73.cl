//{"blurz_a":4,"blurz_b":3,"blurz_g":2,"blurz_r":1,"depth":9,"input":0,"r_sigma":11,"s_sigma":10,"sh":8,"smoothed":5,"sw":7,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilateral_interpolate(global const float4* input, global const float2* blurz_r, global const float2* blurz_g, global const float2* blurz_b, global const float2* blurz_a, global float4* smoothed, int width, int sw, int sh, int depth, int s_sigma, float r_sigma) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const float xf = (float)(x) / s_sigma;
  const float yf = (float)(y) / s_sigma;
  const float4 zf = input[hook(0, y * width + x)] / r_sigma;

  float8 val;

  int x1 = (int)xf;
  int y1 = (int)yf;
  int4 z1 = convert_int4(zf);

  int x2 = min(x1 + 1, sw - 1);
  int y2 = min(y1 + 1, sh - 1);
  int4 z2 = min(z1 + 1, depth - 1);

  float x_alpha = xf - x1;
  float y_alpha = yf - y1;
  float4 z_alpha = zf - floor(zf);

  val.s04 = mix(mix(mix(blurz_r[hook(1, x1 + sw * (y1 + z1.x * sh))], blurz_r[hook(1, x2 + sw * (y1 + z1.x * sh))], x_alpha), mix(blurz_r[hook(1, x1 + sw * (y2 + z1.x * sh))], blurz_r[hook(1, x2 + sw * (y2 + z1.x * sh))], x_alpha), y_alpha), mix(mix(blurz_r[hook(1, x1 + sw * (y1 + z2.x * sh))], blurz_r[hook(1, x2 + sw * (y1 + z2.x * sh))], x_alpha), mix(blurz_r[hook(1, x1 + sw * (y2 + z2.x * sh))], blurz_r[hook(1, x2 + sw * (y2 + z2.x * sh))], x_alpha), y_alpha), z_alpha.x);

  val.s15 = mix(mix(mix(blurz_g[hook(2, x1 + sw * (y1 + z1.y * sh))], blurz_g[hook(2, x2 + sw * (y1 + z1.y * sh))], x_alpha), mix(blurz_g[hook(2, x1 + sw * (y2 + z1.y * sh))], blurz_g[hook(2, x2 + sw * (y2 + z1.y * sh))], x_alpha), y_alpha), mix(mix(blurz_g[hook(2, x1 + sw * (y1 + z2.y * sh))], blurz_g[hook(2, x2 + sw * (y1 + z2.y * sh))], x_alpha), mix(blurz_g[hook(2, x1 + sw * (y2 + z2.y * sh))], blurz_g[hook(2, x2 + sw * (y2 + z2.y * sh))], x_alpha), y_alpha), z_alpha.y);

  val.s26 = mix(mix(mix(blurz_b[hook(3, x1 + sw * (y1 + z1.z * sh))], blurz_b[hook(3, x2 + sw * (y1 + z1.z * sh))], x_alpha), mix(blurz_b[hook(3, x1 + sw * (y2 + z1.z * sh))], blurz_b[hook(3, x2 + sw * (y2 + z1.z * sh))], x_alpha), y_alpha), mix(mix(blurz_b[hook(3, x1 + sw * (y1 + z2.z * sh))], blurz_b[hook(3, x2 + sw * (y1 + z2.z * sh))], x_alpha), mix(blurz_b[hook(3, x1 + sw * (y2 + z2.z * sh))], blurz_b[hook(3, x2 + sw * (y2 + z2.z * sh))], x_alpha), y_alpha), z_alpha.z);

  val.s37 = mix(mix(mix(blurz_a[hook(4, x1 + sw * (y1 + z1.w * sh))], blurz_a[hook(4, x2 + sw * (y1 + z1.w * sh))], x_alpha), mix(blurz_a[hook(4, x1 + sw * (y2 + z1.w * sh))], blurz_a[hook(4, x2 + sw * (y2 + z1.w * sh))], x_alpha), y_alpha), mix(mix(blurz_a[hook(4, x1 + sw * (y1 + z2.w * sh))], blurz_a[hook(4, x2 + sw * (y1 + z2.w * sh))], x_alpha), mix(blurz_a[hook(4, x1 + sw * (y2 + z2.w * sh))], blurz_a[hook(4, x2 + sw * (y2 + z2.w * sh))], x_alpha), y_alpha), z_alpha.w);

  smoothed[hook(5, y * width + x)] = val.s0123 / val.s4567;
}