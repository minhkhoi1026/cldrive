//{"alpha_g":3,"beta_g":4,"normal":0,"north_hemisphere":1,"south_hemisphere":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gauss_sphere(volatile global float4* normal, global int* north_hemisphere, global int* south_hemisphere, const float alpha_g, const float beta_g) {
 private
  const float beta = beta_g;
 private
  const float alpha = alpha_g;
 private
  const int rows = 2 * (1 + (int)ceil(beta / alpha)) + 1;

 private
  int index = get_global_id(0);
 private
  float tmp;
 private
  int2 coord;
 private
  float4 n = normal[hook(0, index)];

  if (n.z < 0) {
    tmp = (beta + alpha) / (alpha - n.z);
    coord = convert_int2((float2)(floor(tmp * n.xy))) + (int2)(rows / 2, rows / 2);
   private
    int tex = coord.y * rows + coord.x;

    atomic_inc(&south_hemisphere[hook(2, tex)]);
  }

  else {
    tmp = (beta + alpha) / (alpha + n.z);
    coord = convert_int2((float2)(floor(tmp * n.xy))) + (int2)(rows / 2, rows / 2);
   private
    int tex = coord.y * rows + coord.x;
    atomic_inc(&north_hemisphere[hook(1, tex)]);
  }
}