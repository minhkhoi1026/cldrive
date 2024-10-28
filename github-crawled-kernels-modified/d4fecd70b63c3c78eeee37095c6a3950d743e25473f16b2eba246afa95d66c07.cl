//{"a":14,"alpha":7,"arr":11,"beta":8,"cluster_num":5,"count":3,"data":1,"labels":0,"logp":12,"logpost":9,"n":4,"outcome_num":6,"p":13,"rand":10,"uniq_label":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(11, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(11, i)]);
  }
  return result;
}

float min_arr(global float* arr, int start, int length) {
  float result = arr[hook(11, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmin(result, arr[hook(11, i)]);
  }
  return result;
}

float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(11, i)];
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(12, i)] = native_powr(exp(1.0f), logp[hook(12, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(12, i)] = logp[hook(12, i)] / p_sum;
  }
}

int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0;
  for (int i = start; i < start + a_size; i++) {
    total += p[hook(13, i)];
    if (total > rand)
      return a[hook(14, i - start)];
  }
  return a[hook(14, a_size - 1)];
}

kernel void cat_logpost(global unsigned int* labels, global unsigned int* data, global unsigned int* uniq_label, global float* count, global unsigned int* n, unsigned int cluster_num, unsigned int outcome_num, float alpha, float beta, global float* logpost, global float* rand) {
  unsigned int data_size = get_global_size(0);
  unsigned int i = get_global_id(0);
  unsigned int c = get_global_id(1);
  unsigned int old_label = labels[hook(0, i)];
  unsigned int new_label = uniq_label[hook(2, c)];
  unsigned int new_size = n[hook(4, c)];
  unsigned int original_cluster = old_label == new_label;
  float loglik;

  loglik = (beta + count[hook(3, outcome_num * c + data[ihook(1, i))] - original_cluster) / (outcome_num * beta + new_size - original_cluster);

  loglik += (new_size > 0) ? log(new_size / (alpha + data_size)) : log(alpha / (alpha + data_size));
  logpost[hook(9, i * cluster_num + c)] = loglik;
}