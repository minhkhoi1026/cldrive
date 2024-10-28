//{"chi_buffer":0,"data_err":1,"n":3,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void loglike(global float* chi_buffer, global float* data_err, global float* output, private unsigned int n) {
  size_t i = get_global_id(0);

  if (i < n) {
    output[hook(2, i)] = -1 * native_log(data_err[hook(1, i)]) - chi_buffer[hook(0, i)] * chi_buffer[hook(0, i)] / 2;
  }
}