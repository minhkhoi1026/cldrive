//{"curve":2,"in":0,"num_sampling_points":3,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_contrast_curve(global const float2* in, global float2* out, global float* curve, int num_sampling_points) {
  int gid = get_global_id(0);
  float2 in_v = in[hook(0, gid)];
  int x = in_v.x * num_sampling_points;
  float y;

  if (x < 0)
    y = curve[hook(2, 0)];
  else if (x < num_sampling_points)
    y = curve[hook(2, x)];
  else
    y = curve[hook(2, num_sampling_points - 1)];

  out[hook(1, gid)] = (float2)(y, in_v.y);
}