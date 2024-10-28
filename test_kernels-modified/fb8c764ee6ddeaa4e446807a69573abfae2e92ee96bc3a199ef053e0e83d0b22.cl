//{"inv_traces":3,"is_pm_matrix":4,"matrix":0,"numtraces":2,"offset_matrix":5,"offset_sum":6,"offset_sum_pow_2":7,"pmm_matrix":10,"somatorio":8,"somatorio_pow_2":9,"wMatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void person_corr_red(global float* matrix, const int wMatrix, const int numtraces, const float inv_traces, const int is_pm_matrix, const int offset_matrix, const int offset_sum, const int offset_sum_pow_2) {
  global float* pmm_matrix = matrix + offset_matrix;
  global float* somatorio = matrix + offset_sum;
  global float* somatorio_pow_2 = matrix + offset_sum_pow_2;
  int i = get_global_id(0);
  int index = i;
  if (i < wMatrix) {
    somatorio[hook(8, i)] = 0.0;
    somatorio_pow_2[hook(9, i)] = 0.0;
    for (int t = 0; t < numtraces; t++, index += wMatrix) {
      somatorio[hook(8, i)] += pmm_matrix[hook(10, index)];
      somatorio_pow_2[hook(9, i)] += pmm_matrix[hook(10, index)] * pmm_matrix[hook(10, index)];
    }
    somatorio_pow_2[hook(9, i)] = sqrt(somatorio_pow_2[hook(9, i)] - (inv_traces * somatorio[hook(8, i)] * somatorio[hook(8, i)]));
    if (is_pm_matrix) {
      somatorio[hook(8, i)] *= inv_traces;
    }
  }
}