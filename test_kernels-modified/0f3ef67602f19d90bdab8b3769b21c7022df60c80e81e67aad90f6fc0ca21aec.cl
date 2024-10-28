//{"A":11,"R":14,"b_v":2,"block_elems_num":9,"block_ind":1,"g_is_update":8,"global_R":0,"m_v":4,"matrix_dimensions":7,"start_bv_inds":3,"start_y_inds":6,"v":10,"x":12,"y":13,"y_v":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void custom_dot_prod_ls(global float* A, unsigned int row_n, global float* v, unsigned int ind, float* res) {
  *res = 0.0;
  for (unsigned int j = ind; j < row_n; ++j) {
    if (j == ind) {
      *res += v[hook(10, j)];
    } else {
      *res += A[hook(11, j + ind * row_n)] * v[hook(10, j)];
    }
  }
}

void backwardSolve(global float* R, unsigned int row_n, unsigned int col_n, global float* y, global float* x) {
  for (int i = col_n - 1; i >= 0; i--) {
    x[hook(12, i)] = y[hook(13, i)];
    for (int j = i + 1; j < col_n; ++j) {
      x[hook(12, i)] -= R[hook(14, i + j * row_n)] * x[hook(12, j)];
    }
    x[hook(12, i)] /= R[hook(14, i + i * row_n)];
  }
}

void apply_q_trans_vec_ls(global float* R, unsigned int row_n, unsigned int col_n, global const float* b_v, global float* y) {
  float inn_prod = 0;
  for (unsigned int i = 0; i < col_n; ++i) {
    custom_dot_prod_ls(R, row_n, y, i, &inn_prod);
    for (unsigned int j = i; j < row_n; ++j) {
      if (i == j) {
        y[hook(13, j)] -= b_v[hook(2, i)] * inn_prod;
      } else {
        y[hook(13, j)] -= b_v[hook(2, i)] * inn_prod * R[hook(14, j + i * row_n)];
      }
    }
  }
}

void ls(global float* R, unsigned int row_n, unsigned int col_n, global float* b_v, global float* m_v, global float* y_v) {
  apply_q_trans_vec_ls(R, row_n, col_n, b_v, y_v);

  backwardSolve(R, row_n, col_n, y_v, m_v);
}

kernel void block_least_squares(global float* global_R, global unsigned int* block_ind, global float* b_v, global unsigned int* start_bv_inds, global float* m_v, global float* y_v, global unsigned int* start_y_inds, global unsigned int* matrix_dimensions, global unsigned int* g_is_update,

                                unsigned int block_elems_num) {
  for (unsigned int i = get_global_id(0); i < block_elems_num; i += get_global_size(0)) {
    if ((matrix_dimensions[hook(7, 2 * i)] > 0) && (matrix_dimensions[hook(7, 2 * i + 1)] > 0) && g_is_update[hook(8, i)] > 0) {
      ls(global_R + block_ind[hook(1, i)], matrix_dimensions[hook(7, 2 * i)], matrix_dimensions[hook(7, 2 * i + 1)], b_v + start_bv_inds[hook(3, i)], m_v + start_bv_inds[hook(3, i)], y_v + start_y_inds[hook(6, i)]);
    }
  }
}