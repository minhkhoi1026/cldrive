//{"in":0,"out":1,"preserve":3,"radius":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilateral_filter(global float4* in, global float4* out, const float radius, const float preserve) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int n_radius = ceil(radius);
  int dst_width = get_global_size(0);
  int src_width = dst_width + n_radius * 2;

  int u, v, i, j;
  float4 center_pix = in[hook(0, (gidy + n_radius) * src_width + gidx + n_radius)];
  float4 accumulated = 0.0f;
  float4 tempf = 0.0f;
  float count = 0.0f;
  float diff_map, gaussian_weight, weight;

  for (v = -n_radius; v <= n_radius; ++v) {
    for (u = -n_radius; u <= n_radius; ++u) {
      i = gidx + n_radius + u;
      j = gidy + n_radius + v;

      int gid1d = i + j * src_width;
      tempf = in[hook(0, gid1d)];

      diff_map = exp(-(((center_pix.x - tempf.x) * (center_pix.x - tempf.x)) + ((center_pix.y - tempf.y) * (center_pix.y - tempf.y)) + ((center_pix.z - tempf.z) * (center_pix.z - tempf.z))) * preserve);

      gaussian_weight = exp(-0.5f * (((u) * (u)) + ((v) * (v))) / radius);

      weight = diff_map * gaussian_weight;

      accumulated += tempf * weight;
      count += weight;
    }
  }
  out[hook(1, gidx + gidy * dst_width)] = accumulated / count;
}