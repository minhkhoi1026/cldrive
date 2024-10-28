//{"component":3,"f":1,"r":2,"vectorField":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void MGGVFInit(read_only image3d_t vectorField, global float* f, global float* r, private int component) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  const float4 v = read_imagef(vectorField, sampler, pos);
  const float sqrMag = v.x * v.x + v.y * v.y + v.z * v.z;
  float f_value, r_value;
  if (component == 1) {
    f_value = v.x;
    r_value = -v.x * sqrMag;
  } else if (component == 2) {
    f_value = v.y;
    r_value = -v.y * sqrMag;
  } else {
    f_value = v.z;
    r_value = -v.z * sqrMag;
  }

  f[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = f_value;
  r[hook(2, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = r_value;
}