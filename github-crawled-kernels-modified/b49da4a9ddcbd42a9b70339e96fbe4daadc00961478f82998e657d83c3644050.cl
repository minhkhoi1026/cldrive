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

kernel void cat_logpost_loopy(global unsigned int* labels, global int* data, global unsigned int* uniq_label, global unsigned int* count, global unsigned int* n, unsigned int cluster_num, unsigned int outcome_num, float alpha, float beta, global float* logpost, global float* rand) {
  unsigned int i = get_global_id(0);
  unsigned int data_size = get_global_size(0);
  unsigned int old_label = labels[hook(0, i)];
  unsigned int new_label;
  unsigned int new_size;
  unsigned int original_cluster;
  unsigned int empty_n = 1;

  for (int c = 0; c < cluster_num; c++) {
    new_label = uniq_label[hook(2, c)];
    new_size = n[hook(4, c)];
    empty_n += (old_label == new_label && new_size == 1);
    original_cluster = old_label == new_label;

    logpost[hook(9, i * cluster_num + c)] = (beta + count[hook(3, outcome_num * c + data[ihook(1, i))] - original_cluster) / (outcome_num * beta + new_size - original_cluster);

    logpost[hook(9, i * cluster_num + c)] += (new_size > original_cluster) ? log((new_size - original_cluster) / (alpha + data_size - 1)) : log(alpha / empty_n / (alpha + data_size - 1));
  }
  lognormalize(logpost, i * cluster_num, cluster_num);

  labels[hook(0, i)] = sample(cluster_num, uniq_label, logpost, i * cluster_num, rand[hook(10, i)]);
}