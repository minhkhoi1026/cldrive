//{"Bracket":1,"K":4,"Phi":0,"a_2":2,"a_4":3,"dx":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 1 | 6 | 0x10;
inline float4 laplacian_2d(read_only image2d_t Phi, float4 phi, const float dx, float2 normalizedCoord, int2 size) {
  float incrementx = 1.0f / size.x;
  float incrementy = 1.0f / size.y;

  float4 xm = (read_imagef(Phi, sampler, (normalizedCoord + (float2){-incrementx, 0})));
  float4 xp = (read_imagef(Phi, sampler, (normalizedCoord + (float2){incrementx, 0})));
  float4 ym = (read_imagef(Phi, sampler, (normalizedCoord + (float2){0, -incrementy})));
  float4 yp = (read_imagef(Phi, sampler, (normalizedCoord + (float2){0, incrementy})));

  float4 xym = (read_imagef(Phi, sampler, (normalizedCoord + (float2){-incrementx, -incrementy})));
  float4 xyp = (read_imagef(Phi, sampler, (normalizedCoord + (float2){incrementx, incrementy})));
  float4 xpym = (read_imagef(Phi, sampler, (normalizedCoord + (float2){incrementx, -incrementy})));
  float4 xmyp = (read_imagef(Phi, sampler, (normalizedCoord + (float2){-incrementx, incrementy})));

  return ((xm + xp + ym + yp) / 2.0f + (xyp + xym + xmyp + xpym) / 4.0f - 3.0f * phi) / (dx * dx);
}

kernel void brac_2d(read_only image2d_t Phi, write_only image2d_t Bracket, const float a_2, const float a_4, const float K, const float dx) {
  int2 coord = {get_global_id(0), get_global_id(1)};
  int2 size = {get_global_size(0), get_global_size(1)};
  float2 normalizedCoord = (float2)((float)coord.x / size.x, (float)coord.y / size.y);

  float4 phi = (read_imagef(Phi, sampler, normalizedCoord).x);

  float4 laplacian = laplacian_2d(Phi, phi, dx, normalizedCoord, size);

  float4 bracket = -2.0f * K * laplacian + a_2 * phi + a_4 * phi * phi * phi;

  write_imagef(Bracket, coord, bracket);
}