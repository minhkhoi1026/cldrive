//{"dest":2,"dest_in":0,"dest_in_step":3,"dest_step":5,"vert":1,"vert_step":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) kernel void scan3_F64(global double* dest_in, global double* vert, global double* dest, int dest_in_step, int vert_step, int dest_step) {
  dest_in_step /= sizeof(double);
  dest_step /= sizeof(double);
  vert_step /= sizeof(double);

  const int gx = get_global_id(0);
  const int gy = get_global_id(1);
  const int tx = (get_global_id(0) / (8 * 8)) - 1;

  if (tx < 0)
    return;

  double Outside = vert[hook(1, gy * vert_step + tx)];

  double Partial = dest_in[hook(0, gy * dest_in_step + gx)];

  dest[hook(2, gy * dest_step + gx)] = Partial + Outside;
}