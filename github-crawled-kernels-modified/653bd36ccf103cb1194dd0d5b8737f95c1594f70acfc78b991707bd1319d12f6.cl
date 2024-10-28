//{"dt":0,"inImg":2,"outImg":3,"vel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t nearest = 1 | 6 | 0x10;
constant sampler_t linear = 1 | 6 | 0x20;
kernel void simpleAdvect(float dt, constant float2* vel, read_only image2d_t inImg, write_only image2d_t outImg) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  float2 x_n = (convert_float2(coord) + (float2)(0.5f, 0.5f)) / convert_float2(get_image_dim(inImg));

  float2 v = *vel;
  if (x_n.y > 0.5f)
    v.x = -v.x;
  if (x_n.x > 0.5f)
    v.y = -v.y;

  float2 x_nHalf = x_n - 0.5f * dt * v;
  float2 x_nS = x_nHalf - dt * v;

  float4 tVal = read_imagef(inImg, linear, x_nS);
  write_imagef(outImg, coord, tVal);
}