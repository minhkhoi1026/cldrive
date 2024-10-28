//{"accumFit":3,"fit_prob":2,"fitness":1,"pop_len":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fit_sum(int pop_len, global float* fitness, global float* fit_prob, global float* accumFit) {
  int tid = get_global_id(0);

  if (tid < pop_len) {
    float sum = 0.0f;

    for (int i = 0; i <= tid; i++)
      sum += fitness[hook(1, i)];
    fit_prob[hook(2, tid)] = sum;

    if (tid == (pop_len - 1))
      *accumFit = sum;
  }
}