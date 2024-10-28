//{"cost":4,"float3":2,"gamma":11,"in":0,"length":12,"midx":8,"midy":9,"o_shape":10,"out":1,"radius0":13,"rdiff":14,"roi_x":6,"roi_y":7,"scale":3,"sint":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vignette_cl(global const float4* in, global float4* out, float4 float3, float scale, float cost, float sint, int roi_x, int roi_y, int midx, int midy, int o_shape, float gamma, float length, float radius0, float rdiff) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int gid = gidx + gidy * get_global_size(0);
  float strength = 0.0f;
  float u, v, costy, sinty;
  int x, y;
  x = gidx + roi_x;
  y = gidy + roi_y;
  sinty = sint * (y - midy) - midx;
  costy = cost * (y - midy) + midy;

  u = cost * (x - midx) - sinty;
  v = sint * (x - midx) + costy;

  if (length == 0.0f)
    strength = 0.0f;
  else {
    switch (o_shape) {
      case 0:
        strength = hypot((u - midx) / scale, v - midy);
        break;

      case 1:
        strength = fmax(fabs(u - midx) / scale, fabs(v - midy));
        break;

      case 2:
        strength = fabs(u - midx) / scale + fabs(v - midy);
        break;
    }
    strength /= length;
    strength = (strength - radius0) / rdiff;
  }

  if (strength < 0.0f)
    strength = 0.0f;
  if (strength > 1.0f)
    strength = 1.0f;

  if (gamma > 1.9999f && gamma < 2.0001f)
    strength *= strength;
  else if (gamma != 1.0f)
    strength = pow(strength, gamma);

  out[hook(1, gid)] = in[hook(0, gid)] * (1.0f - strength) + float3 * strength;
}