//{"R_q":7,"R_u":1,"R_u_u":4,"block_elems_num":11,"block_ind_q":8,"block_ind_u":2,"block_ind_u_u":5,"g_is_update":10,"matrix_dimensions":0,"matrix_dimensions_q":9,"matrix_dimensions_u":3,"matrix_dimensions_u_u":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void assemble_upper_part(global float* R_q, unsigned int row_n_q, unsigned int col_n_q, global float* R_u, unsigned int row_n_u, unsigned int col_n_u, unsigned int col_n, unsigned int diff) {
  for (unsigned int i = 0; i < col_n_q; ++i) {
    for (unsigned int j = 0; j < diff; ++j) {
      R_q[hook(7, i * row_n_q + j)] = R_u[hook(1, i * row_n_u + j + col_n)];
    }
  }
}

void assemble_lower_part(global float* R_q, unsigned int row_n_q, unsigned int col_n_q, global float* R_u_u, unsigned int row_n_u_u, unsigned int col_n_u_u, unsigned int diff) {
  for (unsigned int i = 0; i < col_n_u_u; ++i) {
    for (unsigned int j = 0; j < row_n_u_u; ++j) {
      R_q[hook(7, i * row_n_q + j + diff)] = R_u_u[hook(4, i * row_n_u_u + j)];
    }
  }
}

void assemble_qr_block(global float* R_q, unsigned int row_n_q, unsigned int col_n_q, global float* R_u, unsigned int row_n_u, unsigned int col_n_u, global float* R_u_u, unsigned int row_n_u_u, unsigned int col_n_u_u, unsigned int col_n) {
  unsigned int diff = row_n_u - col_n;
  assemble_upper_part(R_q, row_n_q, col_n_q, R_u, row_n_u, col_n_u, col_n, diff);
  if (diff > 0) {
    assemble_lower_part(R_q, row_n_q, col_n_q, R_u_u, row_n_u_u, col_n_u_u, diff);
  }
}

kernel void block_qr_assembly(global unsigned int* matrix_dimensions, global float* R_u, global unsigned int* block_ind_u, global unsigned int* matrix_dimensions_u, global float* R_u_u, global unsigned int* block_ind_u_u, global unsigned int* matrix_dimensions_u_u, global float* R_q, global unsigned int* block_ind_q, global unsigned int* matrix_dimensions_q, global unsigned int* g_is_update,

                              unsigned int block_elems_num) {
  for (unsigned int i = get_global_id(0); i < block_elems_num; i += get_global_size(0)) {
    if ((matrix_dimensions[hook(0, 2 * i)] > 0) && (matrix_dimensions[hook(0, 2 * i + 1)] > 0) && g_is_update[hook(10, i)] > 0) {
      assemble_qr_block(R_q + block_ind_q[hook(8, i)], matrix_dimensions_q[hook(9, 2 * i)], matrix_dimensions_q[hook(9, 2 * i + 1)], R_u + block_ind_u[hook(2, i)], matrix_dimensions_u[hook(3, 2 * i)], matrix_dimensions_u[hook(3, 2 * i + 1)], R_u_u + block_ind_u_u[hook(5, i)], matrix_dimensions_u_u[hook(6, 2 * i)], matrix_dimensions_u_u[hook(6, 2 * i + 1)], matrix_dimensions[hook(0, 2 * i + 1)]);
    }
  }
}