//{"a_mat":1,"p_mat":3,"prod_mat":4,"q_mat":2,"u_vec":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void qr_32f(local float* u_vec, global float* a_mat, global float* q_mat, global float* p_mat, global float* prod_mat) {
  local float u_length_squared, dot;
  float prod, vec_length = 0.0f;

  int id = get_local_id(2);
  int num_cols = get_global_size(2);

  u_vec[hook(0, id)] = a_mat[hook(1, id * num_cols)];
  barrier(0x01);

  if (id == 0) {
    for (int i = 1; i < num_cols; i++) {
      vec_length += u_vec[hook(0, i)] * u_vec[hook(0, i)];
    }
    u_length_squared = vec_length;
    vec_length = sqrt(vec_length + u_vec[hook(0, 0)] * u_vec[hook(0, 0)]);
    a_mat[hook(1, 0)] = vec_length;
    u_vec[hook(0, 0)] -= vec_length;
    u_length_squared += u_vec[hook(0, 0)] * u_vec[hook(0, 0)];
  } else {
    a_mat[hook(1, id * num_cols)] = 0.0f;
  }
  barrier(0x02);

  for (int i = 1; i < num_cols; i++) {
    dot = 0.0f;
    if (id == 0) {
      for (int j = 0; j < num_cols; j++) {
        dot += a_mat[hook(1, j * num_cols + i)] * u_vec[hook(0, j)];
      }
    }
    barrier(0x01);
    a_mat[hook(1, id * num_cols + i)] -= 2 * u_vec[hook(0, id)] * dot / u_length_squared;
  }

  for (int i = 0; i < num_cols; i++) {
    q_mat[hook(2, id * num_cols + i)] = -2 * u_vec[hook(0, i)] * u_vec[hook(0, id)] / u_length_squared;
  }
  q_mat[hook(2, id * num_cols + id)] += 1;
  barrier(0x02);

  for (int col = 1; col < num_cols - 1; col++) {
    u_vec[hook(0, id)] = a_mat[hook(1, id * num_cols + col)];
    barrier(0x01);

    if (id == col) {
      vec_length = 0.0f;
      for (int i = col + 1; i < num_cols; i++) {
        vec_length += u_vec[hook(0, i)] * u_vec[hook(0, i)];
      }
      u_length_squared = vec_length;
      vec_length = sqrt(vec_length + u_vec[hook(0, col)] * u_vec[hook(0, col)]);
      u_vec[hook(0, col)] -= vec_length;
      u_length_squared += u_vec[hook(0, col)] * u_vec[hook(0, col)];
      a_mat[hook(1, col * num_cols + col)] = vec_length;
    } else if (id > col) {
      a_mat[hook(1, id * num_cols + col)] = 0.0f;
    }
    barrier(0x02);

    for (int i = col + 1; i < num_cols; i++) {
      if (id == 0) {
        dot = 0.0f;
        for (int j = col; j < num_cols; j++) {
          dot += a_mat[hook(1, j * num_cols + i)] * u_vec[hook(0, j)];
        }
      }
      barrier(0x01);

      if (id >= col)
        a_mat[hook(1, id * num_cols + i)] -= 2 * u_vec[hook(0, id)] * dot / u_length_squared;
      barrier(0x02);
    }

    if (id >= col) {
      for (int i = col; i < num_cols; i++) {
        p_mat[hook(3, id * num_cols + i)] = -2 * u_vec[hook(0, i)] * u_vec[hook(0, id)] / u_length_squared;
      }
      p_mat[hook(3, id * num_cols + id)] += 1;
    }
    barrier(0x02);

    for (int i = col; i < num_cols; i++) {
      prod = 0.0f;
      for (int j = col; j < num_cols; j++) {
        prod += q_mat[hook(2, id * num_cols + j)] * p_mat[hook(3, j * num_cols + i)];
      }
      prod_mat[hook(4, id * num_cols + i)] = prod;
    }
    barrier(0x02);

    for (int i = col; i < num_cols; i++) {
      q_mat[hook(2, id * num_cols + i)] = prod_mat[hook(4, id * num_cols + i)];
    }
    barrier(0x02);
  }
}