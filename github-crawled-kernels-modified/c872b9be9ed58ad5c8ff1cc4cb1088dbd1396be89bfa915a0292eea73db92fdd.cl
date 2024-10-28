//{"ndim_fac":0,"odd_buffer":2,"tcf_buffer":3,"tcf_window":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void first_tcf(global const int* ndim_fac, global int* tcf_window, global float* odd_buffer, global float* tcf_buffer) {
  int I0, J0, work_id = get_global_id(0);
  for (I0 = 0; I0 < *tcf_window - work_id; I0++) {
    for (J0 = 0; J0 < *ndim_fac; J0++) {
      tcf_buffer[hook(3, work_id)] += odd_buffer[hook(2, I0 * *ndim_fac + J0)] * odd_buffer[hook(2, (I0 + work_id) * *ndim_fac + J0)];
    }
  }
}