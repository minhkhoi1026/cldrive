//{"N":7,"beta":3,"change":5,"log_g_old":8,"new_fixed_beta":0,"num_of_predictors":6,"outcome":1,"rand":4,"sigma2":9,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void infer_fixed_beta(global float* new_fixed_beta, global float* outcome, global float* x, global float* beta, global float* rand, global int* change, unsigned int num_of_predictors, unsigned int N, float log_g_old, float sigma2) {
  unsigned int beta_idx = get_global_id(0);

  log_g_old += 0;
  float log_g_new = 0;

  float resid_ss = 0;
  float predicted_outcome;
  for (unsigned int n = 0; n < N; n++) {
    predicted_outcome = 0;
    for (unsigned int i = 0; i < num_of_predictors; i++) {
      if (beta_idx != i)
        predicted_outcome += x[hook(2, n * num_of_predictors + i)] * beta[hook(3, i)];
      else
        predicted_outcome += x[hook(2, n * num_of_predictors + i)] * new_fixed_beta[hook(0, beta_idx)];
    }
    resid_ss += pow(outcome[hook(1, n)] - predicted_outcome, 2);
  }
  log_g_new += -(1 / (2 * sigma2)) * resid_ss;

  float log_q_old = 0;
  float log_q_new = 0;

  float moving_logprob = (log_g_new + log_q_old) - (log_g_old + log_q_new);

  change[hook(5, beta_idx)] = log(rand[hook(4, beta_idx)]) < moving_logprob;
}