//{"R":0,"R_u":3,"R_u_u":6,"block_elems_num":13,"block_ind":1,"block_ind_r":10,"block_ind_u":4,"block_ind_u_u":7,"gR":14,"g_R":9,"g_is_update":12,"matrix_dimensions":2,"matrix_dimensions_r":11,"matrix_dimensions_u":5,"matrix_dimensions_u_u":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void assemble_r(global float* gR, unsigned int row_n_r, unsigned int col_n_r, global float* R, unsigned int row_n, unsigned int col_n) {
  for (unsigned int i = 0; i < col_n; ++i) {
    for (unsigned int j = 0; j < row_n; ++j) {
      gR[hook(14, i * row_n_r + j)] = R[hook(0, i * row_n + j)];
    }
  }
}

void assemble_r_u(global float* gR, unsigned int row_n_r, unsigned int col_n_r, global float* R_u, unsigned int row_n_u, unsigned int col_n_u, unsigned int col_n) {
  for (unsigned int i = 0; i < col_n_u; ++i) {
    for (unsigned int j = 0; j < col_n; ++j) {
      gR[hook(14, (i + col_n) * row_n_r + j)] = R_u[hook(3, i * row_n_u + j)];
    }
  }
}

void assemble_r_u_u(global float* gR, unsigned int row_n_r, unsigned int col_n_r, global float* R_u_u, unsigned int row_n_u_u, unsigned int col_n_u_u, unsigned int col_n) {
  for (unsigned int i = 0; i < col_n_u_u; ++i) {
    for (unsigned int j = 0; j < row_n_u_u; ++j) {
      gR[hook(14, (col_n + i) * row_n_r + j + col_n)] = R_u_u[hook(6, i * row_n_u_u + j)];
    }
  }
}

void assemble_r_block(global float* gR, unsigned int row_n_r, unsigned int col_n_r, global float* R, unsigned int row_n, unsigned int col_n, global float* R_u, unsigned int row_n_u, unsigned int col_n_u, global float* R_u_u, unsigned int row_n_u_u, unsigned int col_n_u_u) {
  assemble_r(gR, row_n_r, col_n_r, R, row_n, col_n);
  assemble_r_u(gR, row_n_r, col_n_r, R_u, row_n_u, col_n_u, col_n);
  assemble_r_u_u(gR, row_n_r, col_n_r, R_u_u, row_n_u_u, col_n_u_u, col_n);
}

kernel void block_r_assembly(global float* R, global unsigned int* block_ind, global unsigned int* matrix_dimensions, global float* R_u, global unsigned int* block_ind_u, global unsigned int* matrix_dimensions_u, global float* R_u_u, global unsigned int* block_ind_u_u, global unsigned int* matrix_dimensions_u_u, global float* g_R, global unsigned int* block_ind_r, global unsigned int* matrix_dimensions_r, global unsigned int* g_is_update,

                             unsigned int block_elems_num) {
  for (unsigned int i = get_global_id(0); i < block_elems_num; i += get_global_size(0)) {
    if ((matrix_dimensions[hook(2, 2 * i)] > 0) && (matrix_dimensions[hook(2, 2 * i + 1)] > 0) && g_is_update[hook(12, i)] > 0) {
      assemble_r_block(g_R + block_ind_r[hook(10, i)], matrix_dimensions_r[hook(11, 2 * i)], matrix_dimensions_r[hook(11, 2 * i + 1)], R + block_ind[hook(1, i)], matrix_dimensions[hook(2, 2 * i)], matrix_dimensions[hook(2, 2 * i + 1)], R_u + block_ind_u[hook(4, i)], matrix_dimensions_u[hook(5, 2 * i)], matrix_dimensions_u[hook(5, 2 * i + 1)], R_u_u + block_ind_u_u[hook(7, i)], matrix_dimensions_u_u[hook(8, 2 * i)], matrix_dimensions_u_u[hook(8, 2 * i + 1)]);
    }
  }
}