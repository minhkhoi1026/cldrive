//{"blury":0,"blurz_a":4,"blurz_b":3,"blurz_g":2,"blurz_r":1,"depth":7,"sh":6,"sw":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilateral_blur_z(global const float8* blury, global float2* blurz_r, global float2* blurz_g, global float2* blurz_b, global float2* blurz_a, int sw, int sh, int depth) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  for (int d = 0; d < depth; d++) {
    const int dp = max(d - 1, 0);
    const int dn = min(d + 1, depth - 1);

    float8 v = blury[hook(0, x + sw * (y + dp * sh))] + 4.0f * blury[hook(0, x + sw * (y + d * sh))] + blury[hook(0, x + sw * (y + dn * sh))];

    blurz_r[hook(1, x + sw * (y + d * sh))] = v.s01;
    blurz_g[hook(2, x + sw * (y + d * sh))] = v.s23;
    blurz_b[hook(3, x + sw * (y + d * sh))] = v.s45;
    blurz_a[hook(4, x + sw * (y + d * sh))] = v.s67;
  }
}