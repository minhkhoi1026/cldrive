//{"g_offset":5,"gradient":0,"gradient_loc":2,"gradient_partial_sum":1,"height":3,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void partialReduc(global float* gradient, global float* gradient_partial_sum, local float* gradient_loc, const int height, const int width, const int g_offset) {
  float gradient_acc = 0.f;

  for (int gid = get_global_id(0); gid < height * width; gid += get_global_size(0)) {
    gradient_acc += gradient[hook(0, g_offset + gid)];
  }

  const int lid = get_local_id(0);
  gradient_loc[hook(2, lid)] = gradient_acc;

  barrier(0x01);

  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (lid < offset) {
      gradient_loc[hook(2, lid)] += gradient_loc[hook(2, lid + offset)];
    }
    barrier(0x01);
  }

  const int group_id = get_group_id(0);
  if (lid == 0) {
    gradient_partial_sum[hook(1, group_id)] = gradient_loc[hook(2, 0)];
  }
}