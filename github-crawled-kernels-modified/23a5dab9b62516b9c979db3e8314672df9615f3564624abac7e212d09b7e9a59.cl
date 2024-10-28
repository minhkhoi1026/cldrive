//{"A":7,"A_times_r":4,"b":8,"cols":6,"dim":0,"num_vals":1,"r":2,"result":9,"rows":5,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void steep_desc(int dim, int num_vals, local float* r, local float* x, local float* A_times_r, global int* rows, global int* cols, global float* A, global float* b, global float* result) {
  local float alpha, r_length, iteration;

  int id = get_local_id(0);
  int start_index = 0;
  int end_index = 0;
  float r_dot_r, Ar_dot_r;

  for (int i = id; i < num_vals; i++) {
    if ((rows[hook(5, i)] == id) && (start_index == 0))
      start_index = i;
    else if ((rows[hook(5, i)] == id + 1) && (end_index == 0)) {
      end_index = i - 1;
      break;
    } else if ((i == num_vals - 1) && (end_index == 0)) {
      end_index = i;
    }
  }

  r[hook(2, id)] = b[hook(8, id)];
  x[hook(3, id)] = 0.0f;
  barrier(0x01);

  iteration = 0;
  while ((iteration < 1000) && (r_length >= 0.01)) {
    A_times_r[hook(4, id)] = 0.0f;
    for (int i = start_index; i <= end_index; i++) {
      A_times_r[hook(4, id)] += A[hook(7, i)] * r[hook(2, cols[ihook(6, i))];
    }
    barrier(0x01);

    if (id == 0) {
      r_dot_r = 0.0f;
      Ar_dot_r = 0.0f;
      for (int i = 0; i < dim; i++) {
        r_dot_r += r[hook(2, i)] * r[hook(2, i)];
        Ar_dot_r += A_times_r[hook(4, i)] * r[hook(2, i)];
      }
      alpha = r_dot_r / Ar_dot_r;
    }
    barrier(0x01);

    x[hook(3, id)] += alpha * r[hook(2, id)];
    r[hook(2, id)] -= alpha * A_times_r[hook(4, id)];
    barrier(0x01);

    if (id == 0) {
      r_length = sqrt(r_dot_r);
      iteration++;
    }
    barrier(0x01);
  }

  result[hook(9, 0)] = iteration * 1.0f;
  result[hook(9, 1)] = r_length;
}