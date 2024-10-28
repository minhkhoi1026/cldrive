//{"A":10,"R":0,"b_v":2,"block_elems_num":9,"g_M":12,"g_is_update":7,"l_M":11,"local_buff_R":8,"matrix_dimensions":1,"start_bv_inds":5,"start_matrix_inds":4,"start_v_inds":6,"v":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void dot_prod(local const float* A, unsigned int n, unsigned int beg_ind, float* res) {
  *res = 0;
  for (unsigned int i = beg_ind; i < n; ++i) {
    *res += A[hook(10, (beg_ind - 1) * n + i)] * A[hook(10, (beg_ind - 1) * n + i)];
  }
}

void vector_div(global float* v, unsigned int beg_ind, float b, unsigned int n) {
  for (unsigned int i = beg_ind; i < n; ++i) {
    v[hook(3, i)] /= b;
  }
}

void copy_vector(local const float* A, global float* v, const unsigned int beg_ind, const unsigned int n) {
  for (unsigned int i = beg_ind; i < n; ++i) {
    v[hook(3, i)] = A[hook(10, (beg_ind - 1) * n + i)];
  }
}

void householder_vector(local const float* A, unsigned int j, unsigned int n, global float* v, global float* b) {
  float sg;
  dot_prod(A, n, j + 1, &sg);
  copy_vector(A, v, j + 1, n);
  float mu;
  v[hook(3, j)] = 1.0;

  if (sg == 0) {
    *b = 0;
  } else {
    mu = sqrt(A[hook(10, j * n + j)] * A[hook(10, j * n + j)] + sg);
    if (A[hook(10, j * n + j)] <= 0) {
      v[hook(3, j)] = A[hook(10, j * n + j)] - mu;
    } else {
      v[hook(3, j)] = -sg / (A[hook(10, j * n + j)] + mu);
    }
    *b = 2 * (v[hook(3, j)] * v[hook(3, j)]) / (sg + v[hook(3, j)] * v[hook(3, j)]);

    vector_div(v, j, v[hook(3, j)], n);
  }
}

void custom_inner_prod(local const float* A, global float* v, unsigned int col_ind, unsigned int row_num, unsigned int start_ind, float* res) {
  for (unsigned int i = start_ind; i < row_num; ++i) {
    *res += A[hook(10, col_ind * row_num + i)] * v[hook(3, i)];
  }
}

void apply_householder_reflection(local float* A, unsigned int row_n, unsigned int col_n, unsigned int iter_cnt, global float* v, float b) {
  float in_prod_res;
  for (unsigned int i = iter_cnt + get_local_id(0); i < col_n; i += get_local_size(0)) {
    in_prod_res = 0.0;
    custom_inner_prod(A, v, i, row_n, iter_cnt, &in_prod_res);
    for (unsigned int j = iter_cnt; j < row_n; ++j) {
      A[hook(10, i * row_n + j)] -= b * in_prod_res * v[hook(3, j)];
    }
  }
}

void store_householder_vector(local float* A, unsigned int ind, unsigned int n, global float* v) {
  for (unsigned int i = ind; i < n; ++i) {
    A[hook(10, (ind - 1) * n + i)] = v[hook(3, i)];
  }
}

void single_qr(local float* R, global unsigned int* matrix_dimensions, global float* b_v, global float* v, unsigned int matrix_ind) {
  unsigned int col_n = matrix_dimensions[hook(1, 2 * matrix_ind + 1)];
  unsigned int row_n = matrix_dimensions[hook(1, 2 * matrix_ind)];

  if ((col_n == row_n) && (row_n == 1)) {
    b_v[hook(2, 0)] = 0.0;
    return;
  }
  for (unsigned int i = 0; i < col_n; ++i) {
    if (get_local_id(0) == 0) {
      householder_vector(R, i, row_n, v, b_v + i);
    }
    barrier(0x01);
    apply_householder_reflection(R, row_n, col_n, i, v, b_v[hook(2, i)]);
    barrier(0x01);
    if (get_local_id(0) == 0) {
      if (i < matrix_dimensions[hook(1, 2 * matrix_ind)]) {
        store_householder_vector(R, i + 1, row_n, v);
      }
    }
  }
}

void matrix_from_global_to_local_qr(global float* g_M, local float* l_M, unsigned int row_n, unsigned int col_n, unsigned int mat_start_ind) {
  for (unsigned int i = get_local_id(0); i < col_n; i += get_local_size(0)) {
    for (unsigned int j = 0; j < row_n; ++j) {
      l_M[hook(11, i * row_n + j)] = g_M[hook(12, mat_start_ind + i * row_n + j)];
    }
  }
}
void matrix_from_local_to_global_qr(global float* g_M, local float* l_M, unsigned int row_n, unsigned int col_n, unsigned int mat_start_ind) {
  for (unsigned int i = get_local_id(0); i < col_n; i += get_local_size(0)) {
    for (unsigned int j = 0; j < row_n; ++j) {
      g_M[hook(12, mat_start_ind + i * row_n + j)] = l_M[hook(11, i * row_n + j)];
    }
  }
}

kernel void block_qr(global float* R, global unsigned int* matrix_dimensions, global float* b_v, global float* v, global unsigned int* start_matrix_inds, global unsigned int* start_bv_inds, global unsigned int* start_v_inds, global unsigned int* g_is_update, local float* local_buff_R, unsigned int block_elems_num) {
  for (unsigned int i = get_group_id(0); i < block_elems_num; i += get_num_groups(0)) {
    if ((matrix_dimensions[hook(1, 2 * i)] > 0) && (matrix_dimensions[hook(1, 2 * i + 1)] > 0) && g_is_update[hook(7, i)] > 0) {
      matrix_from_global_to_local_qr(R, local_buff_R, matrix_dimensions[hook(1, 2 * i)], matrix_dimensions[hook(1, 2 * i + 1)], start_matrix_inds[hook(4, i)]);
      barrier(0x01);
      single_qr(local_buff_R, matrix_dimensions, b_v + start_bv_inds[hook(5, i)], v + start_v_inds[hook(6, i)], i);
      barrier(0x01);
      matrix_from_local_to_global_qr(R, local_buff_R, matrix_dimensions[hook(1, 2 * i)], matrix_dimensions[hook(1, 2 * i + 1)], start_matrix_inds[hook(4, i)]);
    }
  }
}