//{"Xt_vec":5,"Xt_vec_chunks":4,"chunk_clusters":2,"local_xt":6,"max_work_group_size":3,"observations":0,"subject_chunks":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_xt_vec_chunks(const int observations, const int subject_chunks, const int chunk_clusters, const int max_work_group_size, global float* Xt_vec_chunks, global float* Xt_vec, local float* local_xt) {
  int snp = get_group_id(1);
  int threadindex = get_local_id(0);

  local_xt[hook(6, threadindex)] = 0.0;

  barrier(0x01);

  for (int chunk_cluster = 0; chunk_cluster < chunk_clusters; ++chunk_cluster) {
    int subject_chunk = chunk_cluster * max_work_group_size + threadindex;

    if (subject_chunk < subject_chunks) {
      local_xt[hook(6, threadindex)] += Xt_vec_chunks[hook(4, snp * subject_chunks + subject_chunk)];
    }

    barrier(0x01);
  }

  for (int s = max_work_group_size / 2; s > 0; s >>= 1) {
    if (threadindex < s) {
      local_xt[hook(6, threadindex)] += local_xt[hook(6, threadindex + s)];
    }

    barrier(0x01);
  }

  if (threadindex == 0) {
    Xt_vec[hook(5, snp)] = local_xt[hook(6, 0)];
  }
  return;
}