//{"V":1,"V0":0,"grid":2,"grid_size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpuvfi(global float* V0, global float* V, global const float* grid, const int grid_size) {
  int gid = get_global_id(0);

  float alpha = 0.5f;
  float beta = 0.7f;

  float grid_p = grid[hook(2, gid)];

  float V_tmp = -(__builtin_inff());
  float u_arg;
  float V_new;

  for (int i = 0; i <= grid_size; i++) {
    u_arg = pow(grid_p, alpha) - grid[hook(2, i)];

    if (u_arg > 0) {
      V_new = log(u_arg) + beta * V0[hook(0, i)];

      if (V_tmp < V_new) {
        V_tmp = V_new;
      }

    } else {
      break;
    }
  }

  V[hook(1, gid)] = V_tmp;
}