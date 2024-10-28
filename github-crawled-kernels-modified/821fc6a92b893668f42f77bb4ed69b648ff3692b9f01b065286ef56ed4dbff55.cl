//{"idxs":1,"in":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void k_gen_1053696_128_1_168_49_21504_float_0_0_cl_permute_gmem_2d_copy(global float* restrict out, global const int* restrict idxs, global const float* restrict in) {
  int gid = get_global_id(0) * get_global_size(1) + get_global_id(1);

  out[hook(0, gid)] = in[hook(2, idxs[ghook(1, gid))];

  out[hook(0, idxs[ghook(1, gid))] = in[hook(2, gid)];
}