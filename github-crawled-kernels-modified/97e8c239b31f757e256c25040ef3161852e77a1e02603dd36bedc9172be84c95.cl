//{"beta":2,"num_of_predictors":4,"outcome":0,"resid2":3,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void resid_squares(global float* outcome, global float* x, global float* beta, global float* resid2, unsigned int num_of_predictors) {
  unsigned int id = get_global_id(0);
  float predicted_outcome = 0;
  for (unsigned int i = 0; i < num_of_predictors; i++) {
    predicted_outcome += beta[hook(2, i)] * x[hook(1, id * num_of_predictors + i)];
  }
  resid2[hook(3, id)] = pow(outcome[hook(0, id)] - predicted_outcome, 2);
}