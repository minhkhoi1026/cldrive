//{"N":10,"beta":4,"change":6,"group":7,"log_g_old":12,"new_random_beta":1,"num_of_predictors":9,"offset":11,"old_random_beta":0,"outcome":2,"rand":5,"sigma2":13,"sigma2_group":8,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void infer_random_beta(global float* old_random_beta, global float* new_random_beta, global float* outcome, global float* x, global float* beta, global float* rand, global int* change, global int* group, global float* sigma2_group, unsigned int num_of_predictors, unsigned int N, unsigned int offset, float log_g_old, float sigma2) {
  unsigned int beta_idx = get_global_id(0);
  unsigned int group_idx = group[hook(7, beta_idx)];

  log_g_old += -(1.0f / (2.0f * sigma2_group[hook(8, group_idx)])) * old_random_beta[hook(0, beta_idx)];
  float log_g_new = -(1.0f / (2.0f * sigma2_group[hook(8, group_idx)])) * new_random_beta[hook(1, beta_idx)];

  float resid_ss = 0;
  float predicted_outcome;
  for (unsigned int n = 0; n < N; n++) {
    predicted_outcome = 0;
    for (unsigned int i = 0; i < num_of_predictors; i++) {
      if (beta_idx + offset != i)
        predicted_outcome += x[hook(3, n * num_of_predictors + i)] * beta[hook(4, i)];
      else
        predicted_outcome += x[hook(3, n * num_of_predictors + i)] * new_random_beta[hook(1, beta_idx)];
    }
    resid_ss += pow(outcome[hook(2, n)] - predicted_outcome, 2);
  }
  log_g_new += -(1 / (2 * sigma2)) * resid_ss;

  float log_q_old = 0;
  float log_q_new = 0;

  float moving_logprob = (log_g_new + log_q_old) - (log_g_old + log_q_new);

  change[hook(6, beta_idx)] = log(rand[hook(5, beta_idx)]) < moving_logprob;
}