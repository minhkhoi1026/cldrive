//{"Lwhite":2,"Lwhite_loc":3,"image":0,"logAvgLum":1,"logAvgLum_loc":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void computeLogAvgLum(read_only image2d_t image, global float* logAvgLum, global float* Lwhite, local float* Lwhite_loc, local float* logAvgLum_loc) {
  float lum;
  float Lwhite_acc = 0.f;
  float logAvgLum_acc = 0.f;

  int2 pos;
  uint4 pixel;
  for (pos.y = get_global_id(1); pos.y < 128; pos.y += get_global_size(1)) {
    for (pos.x = get_global_id(0); pos.x < 16; pos.x += get_global_size(0)) {
      pixel = read_imageui(image, sampler, pos);
      lum = GL_to_CL(pixel.x) * 0.2126 + GL_to_CL(pixel.y) * 0.7152 + GL_to_CL(pixel.z) * 0.0722;

      Lwhite_acc = (lum > Lwhite_acc) ? lum : Lwhite_acc;
      logAvgLum_acc += log(lum + 0.000001);
    }
  }

  pos.x = get_local_id(0);
  pos.y = get_local_id(1);
  const int lid = pos.x + pos.y * get_local_size(0);
  Lwhite_loc[hook(3, lid)] = Lwhite_acc;
  logAvgLum_loc[hook(4, lid)] = logAvgLum_acc;

  barrier(0x01);

  for (int offset = (get_local_size(0) * get_local_size(1)) / 2; offset > 0; offset = offset / 2) {
    if (lid < offset) {
      Lwhite_loc[hook(3, lid)] = (Lwhite_loc[hook(3, lid + offset)] > Lwhite_loc[hook(3, lid)]) ? Lwhite_loc[hook(3, lid + offset)] : Lwhite_loc[hook(3, lid)];
      logAvgLum_loc[hook(4, lid)] += logAvgLum_loc[hook(4, lid + offset)];
    }
    barrier(0x01);
  }

  const int num_work_groups = get_global_size(0) / get_local_size(0);
  const int group_id = get_group_id(0) + get_group_id(1) * num_work_groups;
  if (lid == 0) {
    Lwhite[hook(2, group_id)] = Lwhite_loc[hook(3, 0)];
    logAvgLum[hook(1, group_id)] = logAvgLum_loc[hook(4, 0)];
  }
}