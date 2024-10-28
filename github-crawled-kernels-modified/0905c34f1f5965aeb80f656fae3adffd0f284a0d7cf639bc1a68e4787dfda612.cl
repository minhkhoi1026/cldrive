//{"vectorField":1,"vectorFieldImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void GVF3DInit(read_only image3d_t vectorFieldImage, global float* vectorField) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  vstore3(read_imagef(vectorFieldImage, sampler, pos).xyz, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1), vectorField);
}