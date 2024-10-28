//{"dest":0,"dest_step":2,"horiz":1,"horiz_step":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) kernel void scan4_F64(global double* dest, global double* horiz, int dest_step, int horiz_step) {
  dest_step /= sizeof(double);
  horiz_step /= sizeof(double);

  const int gx = get_global_id(0);
  const int gy = get_global_id(1);

  double Sum = 0;
  for (int i = 0; i <= gy; i++) {
    double v = dest[hook(0, ((i + 1) * 8 - 1) * dest_step + gx)];
    Sum += v;
  }

  horiz[hook(1, gy * horiz_step + gx)] = Sum;
}