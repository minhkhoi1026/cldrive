//{"a":2,"c":1,"i":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(read_only image3d_t i, int4 c, global float4* a) {
  *a = read_imagef(i, c);
}