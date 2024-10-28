//{"array":0,"sdata":1}
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

kernel void array_sum_twostage_loop_lc(global int* array, local int* sdata) {
  size_t local_wg_index = get_local_id(0);
  size_t group_index = get_group_id(0);
  size_t array_size = get_global_size(0);
  size_t global_index = get_global_id(0);
  size_t wg_size = get_local_size(0);
  size_t local_offset = group_index * wg_size;
  size_t group_count = get_num_groups(0);
  size_t offset;

  barrier(0x01);

  offset = wg_size / 2;

  if (local_wg_index < offset)
    sdata[hook(1, local_wg_index)] = array[hook(0, local_offset + local_wg_index + offset)] + array[hook(0, local_offset + local_wg_index)];

  offset >>= 1;
  barrier(0x01);

  for (; offset > 0; offset >>= 1) {
    if (local_wg_index < offset)
      sdata[hook(1, local_wg_index)] += sdata[hook(1, local_wg_index + offset)];

    barrier(0x01);
  }

  if (local_wg_index == 0)
    array[hook(0, group_index)] = sdata[hook(1, 0)];

  barrier(0x02);

  if (global_index == 0) {
    int sum = 0;
    for (size_t i = 0; i < array_size; i += wg_size) {
      sum += array[hook(0, i)];
    }

    array[hook(0, 0)] = sum;
  }
}