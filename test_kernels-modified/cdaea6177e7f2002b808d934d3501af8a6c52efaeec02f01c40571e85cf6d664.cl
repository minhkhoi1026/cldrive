//{"num_p":3,"sorted_indx":2,"x":0,"x_new":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void data_align_dbl(global double* x, global double* x_new, global unsigned int* sorted_indx, unsigned int num_p) {
  unsigned int ip = (unsigned int)get_global_id(0);
  double x_tmp;
  if (ip < num_p) {
    x_tmp = x[hook(0, sorted_indx[ihook(2, ip))];
    x_new[hook(1, ip)] = x_tmp;
  }
}