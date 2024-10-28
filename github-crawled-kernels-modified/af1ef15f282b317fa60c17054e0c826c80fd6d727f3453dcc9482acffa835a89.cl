//{"M":2,"N":1,"displacement_img":3,"in":0,"normal_img":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float map_to_unorm(float x, float max_mag) {
  return (x + max_mag) / (2.0f * max_mag);
}

float4 pack_displacement(float x, float y, float z) {
  float4 res;
  res.x = map_to_unorm(x, 5.0f);
  res.y = map_to_unorm(y, 5.0f);
  res.z = map_to_unorm(z, 5.0f);
  res.w = 0;
  return res;
}

float4 pack_normal(float x, float y, float z) {
  float4 res;
  res.x = map_to_unorm(x, 1);
  res.y = map_to_unorm(y, 1);
  res.z = map_to_unorm(z, 1);
  res.w = 0;
  return res;
}

kernel void export_to_texture(global float* in, int N, int M, write_only image2d_t displacement_img, write_only image2d_t normal_img) {
  const int i = get_global_id(0), j = get_global_id(1);
  if (i > N || j > M)
    return;
  int row_stride = N + 2;
  int buf_stride = (N + 2) * M;
  const int lin_idx = j * row_stride + i;

  float dx = in[hook(0, 0 * buf_stride + lin_idx)];
  float dy = in[hook(0, 1 * buf_stride + lin_idx)];
  float dz = in[hook(0, 2 * buf_stride + lin_idx)];

  float ddx_du = in[hook(0, 3 * buf_stride + lin_idx)] + 1;
  float ddx_dv = in[hook(0, 4 * buf_stride + lin_idx)];
  float ddy_du = in[hook(0, 5 * buf_stride + lin_idx)];
  float ddy_dv = in[hook(0, 6 * buf_stride + lin_idx)];
  float ddz_du = in[hook(0, 7 * buf_stride + lin_idx)];
  float ddz_dv = in[hook(0, 8 * buf_stride + lin_idx)] + 1;

  float nx = ddy_dv * ddz_du - ddz_dv * ddy_du;
  float ny = ddz_dv * ddx_du - ddx_dv * ddz_du;
  float nz = ddx_dv * ddy_du - ddy_dv * ddx_du;
  float n_mag = sqrt(nx * nx + ny * ny + nz * nz);
  nx /= n_mag;
  ny /= n_mag;
  nz /= n_mag;

  int2 dest_coords = (int2)(i, j);
  write_imagef(displacement_img, dest_coords, pack_displacement(dx, dy, dz));
  write_imagef(normal_img, dest_coords, pack_normal(nx, ny, nz));
}