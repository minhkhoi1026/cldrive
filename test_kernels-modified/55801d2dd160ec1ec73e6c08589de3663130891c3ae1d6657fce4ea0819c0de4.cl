//{"a":10,"arr":7,"count":3,"data":2,"data_size":5,"labels":1,"logp":8,"n":4,"outcome_num":6,"p":9,"uniq_label":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(7, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(7, i)]);
  }
  return result;
}

float min_arr(global float* arr, int start, int length) {
  float result = arr[hook(7, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmin(result, arr[hook(7, i)]);
  }
  return result;
}

float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(7, i)];
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(8, i)] = native_powr(exp(1.0f), logp[hook(8, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(8, i)] = logp[hook(8, i)] / p_sum;
  }
}

int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0;
  for (int i = start; i < start + a_size; i++) {
    total += p[hook(9, i)];
    if (total > rand)
      return a[hook(10, i - start)];
  }
  return a[hook(10, a_size - 1)];
}

kernel void compute_suff_stats(global unsigned int* uniq_label, global int* labels, global unsigned int* data, global unsigned int* count, global unsigned int* n, unsigned int data_size, unsigned int outcome_num) {
  unsigned int c = get_global_id(0);
  n[hook(4, c)] = 0;
  for (int i = 0; i < outcome_num; i++) {
    count[hook(3, outcome_num * c + i)] = 0;
  }

  for (int i = 0; i < data_size; i++) {
    n[hook(4, c)] += (uniq_label[hook(0, c)] == labels[hook(1, i)]);
    count[hook(3, outcome_num * c + (uniq_label[chook(0, c) == labels[ihook(1, i)) * data[ihook(2, i))] += (uniq_label[hook(0, c)] == labels[hook(1, i)]);
  }
}