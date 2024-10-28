//{"img":2,"img_height":4,"img_width":3,"norm":6,"point":5,"sampler":1,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void interpolate(image3d_t volume, sampler_t sampler, global float* img, int img_width, int img_height, global float* point, global float3* norm) {
  int pos_x = get_global_id(0);
  int pos_y = get_global_id(1);
  if ((pos_x >= img_width) || (pos_y > img_height))
    return;
  float3 n_norm = normalize(norm[hook(6, 0)]);
  float3 u_norm, v_norm;
  float3 pos;
  float nx = n_norm.x, ny = n_norm.y, nz = n_norm.z;
  float ax = ((nx < 0.0f) ? (-nx) : (nx)), ay = ((ny < 0.0f) ? (-ny) : (ny)), az = ((nz < 0.0f) ? (-nz) : (nz));

  if ((ax >= az) && (ay >= az))
    u_norm = (float3)(-ny, nx, 0.0f);
  else if ((ax >= ay) && (az >= ay))
    u_norm = (float3)(-nz, 0.0f, nx);
  else if ((ay >= ax) && (az >= ax))
    u_norm = (float3)(0.0f, -nz, ny);
  v_norm = cross(n_norm, u_norm);

  float3 tx = (float3)(u_norm.x, v_norm.x, n_norm.x);
  float3 ty = (float3)(u_norm.y, v_norm.y, n_norm.y);
  float3 tz = (float3)(u_norm.z, v_norm.z, n_norm.z);

  float3 pos_uvn = (float3)(2.0f * ((float)pos_x / (float)img_width) - 1.0f, 2.0f * ((float)pos_y / (float)img_height) - 1.0f, 0.0f);
  float4 pos_xyz = (float4)(dot(tx, pos_uvn) + point[hook(5, 0)], dot(ty, pos_uvn) + point[hook(5, 1)], dot(tz, pos_uvn) + point[hook(5, 2)], 0.0f);

  float4 res = read_imagef(volume, sampler, pos_xyz);
  img[hook(2, pos_x + img_width * pos_y)] = res.x;
}