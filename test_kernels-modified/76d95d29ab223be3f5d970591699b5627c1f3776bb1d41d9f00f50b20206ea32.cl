//{"in_pos_x":0,"in_pos_y":1,"in_pos_z":2,"in_vel_x":3,"in_vel_y":4,"in_vel_z":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void wander(global float* in_pos_x, global float* in_pos_y, global float* in_pos_z, global float* in_vel_x, global float* in_vel_y, global float* in_vel_z) {
  const int i = get_global_id(0);

  in_pos_x[hook(0, i)] + 1.0f;
}