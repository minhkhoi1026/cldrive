//{"in":0,"out":1,"threshold":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_red_eye_removal(global const float4* in, global float4* out, float threshold) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float adjusted_red = in_v.x * 0.5133333f;
  float adjusted_green = in_v.y * 1;
  float adjusted_blue = in_v.z * 0.1933333f;
  float adjusted_threshold = (threshold - 0.4f) * 2;
  float tmp;

  if (adjusted_red >= adjusted_green - adjusted_threshold && adjusted_red >= adjusted_blue - adjusted_threshold) {
    tmp = (adjusted_green + adjusted_blue) / (2.0f * 0.5133333f);
    in_v.x = clamp(tmp, 0.0f, 1.0f);
  }
  out[hook(1, gid)] = in_v;
}