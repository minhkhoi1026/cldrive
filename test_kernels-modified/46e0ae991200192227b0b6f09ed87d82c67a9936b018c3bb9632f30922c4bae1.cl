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

kernel void array_sum_loop(global int* array, local int* scratch) {
  size_t local_wg_index = get_local_id(0);
  size_t group_index = get_group_id(0);
  size_t array_size = get_global_size(0);
  size_t global_index = get_global_id(0);

  if (global_index == 0) {
    int sum = 0;

    for (int i = 0; i < array_size; i++) {
      sum += array[hook(0, i)];
    }

    array[hook(0, 0)] = sum;
  }

  barrier(0x02);
}