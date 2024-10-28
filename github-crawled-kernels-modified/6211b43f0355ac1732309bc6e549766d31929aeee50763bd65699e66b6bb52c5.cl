//{"vectorField":0,"vectorField2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void GVF3DFinish(global float* vectorField, global float* vectorField2) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  float4 v;
  v.xyz = vload3(pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1), vectorField);
  v.w = 0;
  v.w = length(v) > 0.0f ? length(v) : 1.0f;

  vstore4(v, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1), vectorField2);
}