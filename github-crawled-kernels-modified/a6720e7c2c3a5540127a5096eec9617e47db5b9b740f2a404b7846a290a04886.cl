//{"face":3,"pitch":2,"size":1,"t":4,"texOut":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_kernel_texture_cube(write_only image2d_t texOut, unsigned int size, unsigned int pitch, int face, float t) {
  const int tx = get_local_id(0);
  const int ty = get_local_id(1);
  const int bw = get_local_size(0);
  const int bh = get_local_size(1);
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= size || y >= size)
    return;

  float theta_x = (2.0f * (float)x) / (float)pitch - 1.0f;
  float theta_y = (2.0f * (float)y) / (float)size - 1.0f;
  float theta = 2.0f * 3.1415926536f * sqrt(theta_x * theta_x + theta_y * theta_y);
  float value = (0.6f + 0.4f * cos(theta + t));

  float4 float3;
  float3.w = 1.0;
  if (face < 3) {
    float3.x = face == 0 ? value : 0.0;
    float3.y = face == 1 ? value : 0.0;
    float3.z = face == 2 ? value : 0.0;
  } else {
    float3.x = face == 3 ? value : 0.5;
    float3.y = face == 4 ? value : 0.5;
    float3.z = face == 5 ? value : 0.5;
  }
  int2 coord = (int2)(x, y);
  write_imagef(texOut, coord, float3);
}