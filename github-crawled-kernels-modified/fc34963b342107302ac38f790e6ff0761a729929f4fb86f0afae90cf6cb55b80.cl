//{"a":3,"c":2,"i":1,"s":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 bar(sampler_t s, read_only image3d_t i, float4 c) {
  return read_imagef(i, s, c);
}

kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(sampler_t s, read_only image3d_t i, float4 c, global float4* a) {
  *a = bar(s, i, c);
}