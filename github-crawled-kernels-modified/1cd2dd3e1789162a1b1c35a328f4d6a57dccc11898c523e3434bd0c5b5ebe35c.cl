//{"Bracket":1,"M":3,"Phi":0,"PhiNext":2,"dt":5,"dx":4}
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

kernel void step_2d(read_only image2d_t Phi, read_only image2d_t Bracket, write_only image2d_t PhiNext, const float M, const float dx, const float dt) {
  int2 coord = {get_global_id(0), get_global_id(1)};
  int2 size = {get_global_size(0), get_global_size(1)};
  float2 normalizedCoord = (float2)((float)coord.x / size.x, (float)coord.y / size.y);

  float4 phi = (read_imagef(Phi, sampler, normalizedCoord).x);
  float4 bracket = (read_imagef(Bracket, sampler, normalizedCoord).x);

  float4 laplacian = laplacian_2d(Bracket, bracket, dx, normalizedCoord, size);

  float4 phi_next = phi + dt * M * laplacian;

  write_imagef(PhiNext, coord, phi_next);
}