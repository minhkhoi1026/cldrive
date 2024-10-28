//{"Xt_vec_chunks":6,"local_floatgeno":11,"mapping":12,"mask_n":10,"max_work_group_size":4,"means":8,"observations":0,"packedgeno_snpmajor":5,"packedstride_snpmajor":3,"precisions":9,"snps":1,"subject_chunks":2,"vec":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_xt_times_vector(const int observations, const int snps, const int subject_chunks, const int packedstride_snpmajor, const int max_work_group_size, global const char* packedgeno_snpmajor, global double* Xt_vec_chunks, global const double* vec, global const double* means, global const double* precisions, global const long* mask_n, local double* local_floatgeno) {
  local double mapping[4];
  mapping[hook(12, 0)] = 0.0;
  mapping[hook(12, 1)] = 9.0;
  mapping[hook(12, 2)] = 1.0;
  mapping[hook(12, 3)] = 2.0;

  int subject_chunk = get_group_id(0);
  int snp = get_group_id(1);
  int threadindex = get_local_id(0);

  double mean = means[hook(8, snp)];
  double precision = precisions[hook(9, snp)];

  local_floatgeno[hook(11, threadindex)] = 0.0;

  int subject_index = subject_chunk * max_work_group_size + threadindex;
  if (subject_index < observations) {
    int row = subject_chunk * max_work_group_size + threadindex;
    int k = 2 * (row & 3);
    char genotype_block = packedgeno_snpmajor[hook(5, snp * packedstride_snpmajor + (row >> 2))];
    int val = (((int)genotype_block) >> k) & 3;
    local_floatgeno[hook(11, threadindex)] = mapping[hook(12, val)];
    local_floatgeno[hook(11, threadindex)] = (local_floatgeno[hook(11, threadindex)] == 9.0 || mask_n[hook(10, subject_index)] == 0) ? 0.0 : (local_floatgeno[hook(11, threadindex)] - mean) * precision * vec[hook(7, subject_index)];

    barrier(0x01);

    for (int s = max_work_group_size / 2; s > 0; s >>= 1) {
      if (threadindex < s) {
        local_floatgeno[hook(11, threadindex)] += local_floatgeno[hook(11, threadindex + s)];
      }

      barrier(0x01);
    }

    if (threadindex == 0) {
      Xt_vec_chunks[hook(6, snp * subject_chunks + subject_chunk)] += local_floatgeno[hook(11, 0)];
    }
  }
  return;
}