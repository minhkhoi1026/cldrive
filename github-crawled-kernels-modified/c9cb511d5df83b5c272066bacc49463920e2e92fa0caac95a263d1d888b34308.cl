//{"dest":2,"dest_in":0,"dest_in_step":3,"dest_step":5,"horiz":1,"horiz_step":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) kernel void scan5_F32(global float* dest_in, global float* horiz, global float* dest, int dest_in_step, int horiz_step, int dest_step) {
  dest_in_step /= sizeof(float);
  dest_step /= sizeof(float);
  horiz_step /= sizeof(float);

  const int gx = get_global_id(0);
  const int gy = get_global_id(1);
  const int ty = (get_global_id(1) / 8) - 1;

  if (ty < 0)
    return;

  float Outside = horiz[hook(1, ty * horiz_step + gx)];

  float Partial = dest_in[hook(0, gy * dest_in_step + gx)];

  dest[hook(2, gy * dest_step + gx)] = Partial + Outside;
}