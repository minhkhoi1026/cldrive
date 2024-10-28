//{"array":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct stable_info {
  double k1;
  double theta0;
  double alfa;
  double alfainvalfa1;
  double mu_0;
  double sigma;
  double xi;
  double xxi_th;
  double c2_part;
  double c1;
  double THETA_TH;
  double beta;
  double xi_coef;
  short is_xxi_negative;
  unsigned int integrand;
  double final_pdf_factor;
  double final_cdf_factor;
  double final_cdf_addition;
  double quantile_tolerance;
  size_t max_reevaluations;
  unsigned int rng_seed_a;
  unsigned int rng_seed_b;
};

kernel void array_sum_twostage_two_wgs(global int* array, local int* scratch) {
  size_t local_wg_index = get_local_id(0);
  size_t group_index = get_group_id(0);
  size_t array_size = get_global_size(0);
  size_t global_index = get_global_id(0);
  size_t wg_size = get_local_size(0);
  size_t local_offset;
  size_t group_count = get_num_groups(0);
  size_t actual_group_count = 2;
  int sum;

  barrier(0x01);

  if (group_index < actual_group_count) {
    for (size_t chunk_index = group_index; chunk_index < group_count; chunk_index += actual_group_count) {
      local_offset = chunk_index * wg_size;

      for (size_t offset = wg_size / 2; offset > 0; offset >>= 1) {
        if (local_wg_index < offset)
          array[hook(0, local_offset + local_wg_index)] += array[hook(0, local_offset + local_wg_index + offset)];

        barrier(0x01);
      }

      if (local_wg_index == 0 && chunk_index != group_index)
        array[hook(0, group_index * wg_size)] += array[hook(0, local_offset)];

      barrier(0x01);
    }

    barrier(0x02);

    if (group_index == 0 && local_wg_index == 0)
      array[hook(0, 0)] += array[hook(0, wg_size)];
  }
}