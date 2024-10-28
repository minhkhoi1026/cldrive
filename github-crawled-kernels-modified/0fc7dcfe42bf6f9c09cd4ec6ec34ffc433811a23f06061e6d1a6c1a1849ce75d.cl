//{"A":12,"R":14,"b_v":4,"block_elems_num":10,"block_ind":1,"block_ind_u":3,"g_M":16,"g_is_update":8,"global_R":0,"global_R_u":2,"l_M":15,"local_R_u":9,"matrix_dimensions":6,"matrix_dimensions_u":7,"start_bv_inds":5,"v":11,"y":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void custom_dot_prod(global float* A, unsigned int row_n, local float* v, unsigned int ind, float* res) {
  *res = 0.0;
  for (unsigned int j = ind; j < row_n; ++j) {
    if (j == ind) {
      *res += v[hook(11, j)];
    } else {
      *res += A[hook(12, j + ind * row_n)] * v[hook(11, j)];
    }
  }
}

void apply_q_trans_vec(global float* R, unsigned int row_n, unsigned int col_n, global float* b_v, local float* y) {
  float inn_prod = 0;
  for (unsigned int i = 0; i < col_n; ++i) {
    custom_dot_prod(R, row_n, y, i, &inn_prod);
    for (unsigned int j = i; j < row_n; ++j) {
      if (i == j) {
        y[hook(13, j)] -= b_v[hook(4, i)] * inn_prod;
      } else {
        y[hook(13, j)] -= b_v[hook(4, i)] * inn_prod * R[hook(14, j + i * row_n)];
      }
    }
  }
}

void q_mult(global float* R, unsigned int row_n, unsigned int col_n, global float* b_v, local float* R_u, unsigned int col_n_u) {
  for (unsigned int i = get_local_id(0); i < col_n_u; i += get_local_size(0)) {
    apply_q_trans_vec(R, row_n, col_n, b_v, R_u + row_n * i);
  }
}

void matrix_from_global_to_local(global float* g_M, local float* l_M, unsigned int row_n, unsigned int col_n, unsigned int mat_start_ind) {
  for (unsigned int i = get_local_id(0); i < col_n; i += get_local_size(0)) {
    for (unsigned int j = 0; j < row_n; ++j) {
      l_M[hook(15, i * row_n + j)] = g_M[hook(16, mat_start_ind + i * row_n + j)];
    }
  }
}

void matrix_from_local_to_global(global float* g_M, local float* l_M, unsigned int row_n, unsigned int col_n, unsigned int mat_start_ind) {
  for (unsigned int i = get_local_id(0); i < col_n; i += get_local_size(0)) {
    for (unsigned int j = 0; j < row_n; ++j) {
      g_M[hook(16, mat_start_ind + i * row_n + j)] = l_M[hook(15, i * row_n + j)];
    }
  }
}

kernel void block_q_mult(global float* global_R, global unsigned int* block_ind, global float* global_R_u, global unsigned int* block_ind_u, global float* b_v, global unsigned int* start_bv_inds, global unsigned int* matrix_dimensions, global unsigned int* matrix_dimensions_u, global unsigned int* g_is_update, local float* local_R_u, unsigned int block_elems_num) {
  for (unsigned int i = get_group_id(0); i < block_elems_num; i += get_num_groups(0)) {
    if ((matrix_dimensions[hook(6, 2 * i)] > 0) && (matrix_dimensions[hook(6, 2 * i + 1)] > 0) && (g_is_update[hook(8, i)] > 0)) {
      matrix_from_global_to_local(global_R_u, local_R_u, matrix_dimensions_u[hook(7, 2 * i)], matrix_dimensions_u[hook(7, 2 * i + 1)], block_ind_u[hook(3, i)]);
      barrier(0x01);
      q_mult(global_R + block_ind[hook(1, i)], matrix_dimensions[hook(6, 2 * i)], matrix_dimensions[hook(6, 2 * i + 1)], b_v + start_bv_inds[hook(5, i)], local_R_u, matrix_dimensions_u[hook(7, 2 * i + 1)]);
      barrier(0x01);
      matrix_from_local_to_global(global_R_u, local_R_u, matrix_dimensions_u[hook(7, 2 * i)], matrix_dimensions_u[hook(7, 2 * i + 1)], block_ind_u[hook(3, i)]);
    }
  }
}