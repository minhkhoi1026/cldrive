//{"a":8,"arr":5,"cluster_num":2,"labels":0,"logp":6,"logpost":4,"p":7,"rand":3,"uniq_label":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(5, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(5, i)]);
  }
  return result;
}

float min_arr(global float* arr, int start, int length) {
  float result = arr[hook(5, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmin(result, arr[hook(5, i)]);
  }
  return result;
}

float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(5, i)];
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(6, i)] = native_powr(exp(1.0f), logp[hook(6, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(6, i)] = logp[hook(6, i)] / p_sum;
  }
}

int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0;
  for (int i = start; i < start + a_size; i++) {
    total += p[hook(7, i)];
    if (total > rand)
      return a[hook(8, i - start)];
  }
  return a[hook(8, a_size - 1)];
}

kernel void resample_labels(global unsigned int* labels, global unsigned int* uniq_label, unsigned int cluster_num, global float* rand, global float* logpost) {
  unsigned int i = get_global_id(0);
  lognormalize(logpost, i * cluster_num, cluster_num);

  labels[hook(0, i)] = sample(cluster_num, uniq_label, logpost, i * cluster_num, rand[hook(3, i)]);
}