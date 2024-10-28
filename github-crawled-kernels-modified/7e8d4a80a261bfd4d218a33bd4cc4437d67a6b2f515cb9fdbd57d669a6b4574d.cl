//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void k_gen_1048576_1_1_4_65536_4_float4_0_1_cl_map_gmem_2d_copy(global float4* restrict out, global const float4* restrict in) {
  int gid = get_global_id(1) * get_global_size(0) + get_global_id(0);

  out[hook(0, gid)] = in[hook(1, gid)];
}