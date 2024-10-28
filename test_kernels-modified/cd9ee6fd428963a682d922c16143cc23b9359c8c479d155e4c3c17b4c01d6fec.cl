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

kernel void array_sum_twostage_half_wgs(global int* array, local int* scratch) {
  size_t local_wg_index = get_local_id(0);
  size_t group_index = get_group_id(0);
  size_t array_size = get_global_size(0);
  size_t global_index = get_global_id(0);
  size_t wg_size = get_local_size(0);
  size_t local_offset;
  size_t group_count = get_num_groups(0);
  size_t actual_group_count = group_count / 2;
  size_t final_reduction_needed_groups = actual_group_count / wg_size;
  int sum;

  if (actual_group_count % wg_size != 0)
    final_reduction_needed_groups += 1;

  barrier(0x01);

  if (group_index < actual_group_count) {
    for (size_t chunk_index = group_index; chunk_index < group_count; chunk_index += actual_group_count) {
      local_offset = chunk_index * wg_size;

      for (size_t offset = wg_size / 2; offset > 0; offset >>= 1) {
        if (local_wg_index < offset)
          array[hook(0, local_offset + local_wg_index)] += array[hook(0, local_offset + local_wg_index + offset)];

        barrier(0x01);
      }

      if (local_wg_index == 0)
        array[hook(0, group_index)] += array[hook(0, local_offset)];

      barrier(0x01);
    }
  }

  barrier(0x02);

  while (final_reduction_needed_groups > 0) {
    if (group_index < final_reduction_needed_groups) {
      size_t actual_reduction_size = wg_size;

      if (group_index == final_reduction_needed_groups - 1)
        actual_reduction_size = actual_reduction_size - final_reduction_needed_groups * wg_size;

      for (size_t offset = wg_size / 2; offset > 0; offset >>= 1) {
        if (local_wg_index < offset && local_wg_index + offset < actual_reduction_size)
          array[hook(0, local_wg_index)] += array[hook(0, (local_wg_index + group_index) * wg_size)];

        barrier(0x01);
      }
    }

    if (final_reduction_needed_groups > 1)
      final_reduction_needed_groups /= wg_size;
    else
      final_reduction_needed_groups = 0;

    barrier(0x02);
  }
}