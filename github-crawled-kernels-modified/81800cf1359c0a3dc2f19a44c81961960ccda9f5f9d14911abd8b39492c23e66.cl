//{"b":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(write_only image2d_t b) {
  write_imagef(b, (int2)(0, 0), (float4)(0, 0, 0, 0));
}