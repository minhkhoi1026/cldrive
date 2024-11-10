//{"a":3,"c":2,"i":1,"s":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(sampler_t s, read_only image3d_t i, float4 c, global int4* a) {
  *a = read_imagei(i, s, c);
}