//{"A":8,"A_times_p":4,"b":9,"cols":7,"dim":0,"num_vals":1,"p":5,"r":2,"result":10,"rows":6,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conj_grad(int dim, int num_vals, local float* r, local float* x, local float* A_times_p, local float* p, global int* rows, global int* cols, global float* A, global float* b, global float* result) {
  local float alpha, r_length, old_r_dot_r, new_r_dot_r;
  local int iteration;

  int id = get_local_id(0);
  int start_index = -1;
  int end_index = -1;
  float Ap_dot_p;

  for (int i = id; i < num_vals; i++) {
    if ((rows[hook(6, i)] == id) && (start_index == -1))
      start_index = i;
    else if ((rows[hook(6, i)] == id + 1) && (end_index == -1)) {
      end_index = i - 1;
      break;
    } else if ((i == num_vals - 1) && (end_index == -1)) {
      end_index = i;
    }
  }

  x[hook(3, id)] = 0.0f;
  r[hook(2, id)] = b[hook(9, id)];
  p[hook(5, id)] = b[hook(9, id)];
  barrier(0x01);

  if (id == 0) {
    old_r_dot_r = 0.0f;
    for (int i = 0; i < dim; i++) {
      old_r_dot_r += r[hook(2, i)] * r[hook(2, i)];
    }
    r_length = sqrt(old_r_dot_r);
  }
  barrier(0x01);

  iteration = 0;
  while ((iteration < 1000) && (r_length >= 0.01)) {
    A_times_p[hook(4, id)] = 0.0f;
    for (int i = start_index; i <= end_index; i++) {
      A_times_p[hook(4, id)] += A[hook(8, i)] * p[hook(5, cols[ihook(7, i))];
    }
    barrier(0x01);

    if (id == 0) {
      Ap_dot_p = 0.0f;
      for (int i = 0; i < dim; i++) {
        Ap_dot_p += A_times_p[hook(4, i)] * p[hook(5, i)];
      }
      alpha = old_r_dot_r / Ap_dot_p;
    }
    barrier(0x01);

    x[hook(3, id)] += alpha * p[hook(5, id)];
    r[hook(2, id)] -= alpha * A_times_p[hook(4, id)];
    barrier(0x01);

    if (id == 0) {
      new_r_dot_r = 0.0f;
      for (int i = 0; i < dim; i++) {
        new_r_dot_r += r[hook(2, i)] * r[hook(2, i)];
      }
      r_length = sqrt(new_r_dot_r);
    }
    barrier(0x01);

    p[hook(5, id)] = r[hook(2, id)] + (new_r_dot_r / old_r_dot_r) * p[hook(5, id)];
    barrier(0x01);

    old_r_dot_r = new_r_dot_r;

    if (id == 0) {
      iteration++;
    }
    barrier(0x01);
  }
  result[hook(10, 0)] = iteration * 1.0f;
  result[hook(10, 1)] = r_length;
}