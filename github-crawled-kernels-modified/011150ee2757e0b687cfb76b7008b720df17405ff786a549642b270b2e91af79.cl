//{"in":0,"out":1,"radius":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void box_blur_ver(global const float4* in, global float4* out, const int radius) {
  const int size = 2 * radius + 1;
  const int gidx = get_global_id(0);
  const int gidy = get_global_id(1);
  const int src_rowstride = get_global_size(0);
  const int dst_rowstride = get_global_size(0);

  const int src_offset = gidx + (gidy + radius) * src_rowstride;
  const int dst_offset = gidx + gidy * dst_rowstride;

  const int src_start_ind = src_offset - radius * src_rowstride;

  float4 mean = 0.0f;

  for (int i = 0; i < size; i++) {
    mean += in[hook(0, src_start_ind + i * src_rowstride)];
  }

  out[hook(1, dst_offset)] = mean / (float)(size);
}