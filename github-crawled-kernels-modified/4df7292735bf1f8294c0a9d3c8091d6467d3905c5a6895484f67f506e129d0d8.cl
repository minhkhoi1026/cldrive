//{"fit_prob":1,"fit_sum":2,"pop_len":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fit_prob(int pop_len, global float* fit_prob, float fit_sum) {
  int tid = get_global_id(0);
  if (tid < pop_len) {
    fit_prob[hook(1, tid)] /= fit_sum;
  }
}