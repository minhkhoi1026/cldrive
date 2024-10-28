//{"curve":2,"in":0,"num_sampling_points":3,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_contrast_curve(global const float2* in, global float2* out, global float* curve, int num_sampling_points) {
  int gid = get_global_id(0);
  float2 in_v = in[hook(0, gid)];

  int idx = (int)fmin(num_sampling_points - 1.0f, fmax(0.0f, in_v.x * num_sampling_points));

  out[hook(1, gid)] = (float2)(curve[hook(2, idx)], in_v.y);
}