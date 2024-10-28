//{"K":6,"K_inv":7,"dest":1,"frame_height":11,"frame_width":10,"mu":9,"n":15,"proj_view":5,"src":0,"t_gk":8,"tsdf_depth":4,"tsdf_extent_d":14,"tsdf_extent_h":13,"tsdf_extent_w":12,"tsdf_height":3,"tsdf_width":2,"weight":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tsdf_kernel(global float* src, global float* dest, const unsigned int tsdf_width, const unsigned int tsdf_height, const unsigned int tsdf_depth, global const float* proj_view, global const float* K, global const float* K_inv, global const float* t_gk, const float mu, const unsigned int frame_width, const unsigned int frame_height, const float tsdf_extent_w, const float tsdf_extent_h, const float tsdf_extent_d, const unsigned int n, global unsigned char* weight) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);
  unsigned int z = get_global_id(2);

  unsigned int idx = x + (tsdf_width)*y + ((tsdf_width) * (tsdf_height)) * z;

  if (n == 0) {
    vstore_half(1.0f, idx, dest);
    weight[hook(16, idx)] = 0;
  }

  if (x > tsdf_width || y > tsdf_height || z > tsdf_depth) {
    return;
  }

  float p_x = ((float)x + 0.5) * tsdf_extent_w / tsdf_width;
  float p_y = ((float)y + 0.5) * tsdf_extent_h / tsdf_height;
  float p_z = ((float)z + 0.5) * tsdf_extent_d / tsdf_depth;
  float4 p = (float4)(p_x, p_y, p_z, 1);

  float3 cam;
  cam.x = proj_view[hook(5, 0)] * p.x + proj_view[hook(5, 1)] * p.y + proj_view[hook(5, 2)] * p.z + proj_view[hook(5, 3)] * p.w;
  cam.y = proj_view[hook(5, 4)] * p.x + proj_view[hook(5, 5)] * p.y + proj_view[hook(5, 6)] * p.z + proj_view[hook(5, 7)] * p.w;
  cam.z = proj_view[hook(5, 8)] * p.x + proj_view[hook(5, 9)] * p.y + proj_view[hook(5, 10)] * p.z + proj_view[hook(5, 11)] * p.w;

  float3 plane;
  plane.x = cam.x * K[hook(6, 0)] + cam.y * K[hook(6, 1)] + cam.z * K[hook(6, 2)];
  plane.y = cam.x * K[hook(6, 3)] + cam.y * K[hook(6, 4)] + cam.z * K[hook(6, 5)];
  plane.z = cam.x * K[hook(6, 6)] + cam.y * K[hook(6, 7)] + cam.z * K[hook(6, 8)];

  float2 uv;
  uv.x = plane.x / plane.z;
  uv.y = plane.y / plane.z;

  int2 x_tild;
  x_tild.x = round(uv.x);
  x_tild.y = round(uv.y);

  if (x_tild.x < 0 || x_tild.x >= frame_width || x_tild.y < 0 || x_tild.y >= frame_height || plane.z < 0.0f) {
    return;
  }

  float v = src[hook(0, x_tild.y * frame_width + x_tild.x)];
  float3 pix = (float3)(x_tild.x, x_tild.y, 1.0f);
  float3 pix_k_inv;
  pix_k_inv.x = dot((float3)(K_inv[hook(7, 0)], K_inv[hook(7, 1)], K_inv[hook(7, 2)]), pix);
  pix_k_inv.y = dot((float3)(K_inv[hook(7, 3)], K_inv[hook(7, 4)], K_inv[hook(7, 5)]), pix);
  pix_k_inv.z = dot((float3)(K_inv[hook(7, 6)], K_inv[hook(7, 7)], K_inv[hook(7, 8)]), pix);
  pix_k_inv *= v;

  float to_measurement = sqrt(dot(pix_k_inv, pix_k_inv));
  float to_voxel = sqrt(dot(cam, cam));

  float sdf = to_measurement - to_voxel;

  if (sdf >= -mu) {
    float tsdf = fmin(1.0f, sdf / mu);

    if (isnan(tsdf))
      return;

    float prev_tsdf = vload_half(idx, dest);

    if (isnan(prev_tsdf))
      prev_tsdf = 0;

    uchar prev_weight = weight[hook(16, idx)];

    uchar new_weight = min(((uchar)254U), prev_weight);
    ++new_weight;

    weight[hook(16, idx)] = new_weight;

    float new_tsdf = (prev_tsdf * prev_weight + tsdf * new_weight) / (prev_weight + new_weight);
    vstore_half(new_tsdf, idx, dest);
  }
}