//{"image":0,"logAvgLum":2,"logAvgLum_loc":3,"lum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void computeLogAvgLum(read_only image2d_t image, global float* lum, global float* logAvgLum, local float* logAvgLum_loc) {
  float luminance;
  float logAvgLum_acc = 0.f;

  int2 pos;
  uint4 pixel;
  for (pos.y = get_global_id(1); pos.y < 128; pos.y += get_global_size(1)) {
    for (pos.x = get_global_id(0); pos.x < 16; pos.x += get_global_size(0)) {
      pixel = read_imageui(image, sampler, pos);
      luminance = GL_to_CL(pixel.x) * 0.2126 + GL_to_CL(pixel.y) * 0.7152 + GL_to_CL(pixel.z) * 0.0722;

      logAvgLum_acc += log(luminance + 0.000001);
      lum[hook(1, pos.x + pos.y * 16)] = luminance;
    }
  }

  pos.x = get_local_id(0);
  pos.y = get_local_id(1);
  const int lid = pos.x + pos.y * get_local_size(0);
  logAvgLum_loc[hook(3, lid)] = logAvgLum_acc;

  barrier(0x01);

  for (int offset = (get_local_size(0) * get_local_size(1)) / 2; offset > 0; offset = offset / 2) {
    if (lid < offset) {
      logAvgLum_loc[hook(3, lid)] += logAvgLum_loc[hook(3, lid + offset)];
    }
    barrier(0x01);
  }

  const int num_work_groups = get_global_size(0) / get_local_size(0);
  const int group_id = get_group_id(0) + get_group_id(1) * num_work_groups;
  if (lid == 0) {
    logAvgLum[hook(2, group_id)] = logAvgLum_loc[hook(3, 0)];
  }
}