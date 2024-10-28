//{"probe_data":0,"probe_sum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scale_probe(global float2* probe_data, float probe_sum) {
  float scale = (float)(1.0f / sqrt(probe_sum));

  size_t ix = get_global_id(0);
  size_t iy = get_global_id(1);
  size_t index = iy * get_global_size(0) + ix;

  float2 pd2 = probe_data[hook(0, index)];
  pd2.s0 *= scale;
  pd2.s1 *= scale;
  probe_data[hook(0, index)] = pd2;
}