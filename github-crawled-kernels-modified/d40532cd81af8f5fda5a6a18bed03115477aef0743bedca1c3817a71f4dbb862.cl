//{"result":0,"vectorField":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void GVF3DResult(global float* result, global float* vectorField) {
  int pos = get_global_id(0) + get_global_id(1) * get_global_size(0) + get_global_id(2) * get_global_size(0) * get_global_size(1);
  float3 v = vload3(pos, vectorField);
  result[hook(0, pos)] = length(v);
}