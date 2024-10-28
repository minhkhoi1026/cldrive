//{"block_elems_num":10,"g_bv":0,"g_bv_r":6,"g_bv_u":3,"g_is_update":9,"matrix_dimensions":2,"matrix_dimensions_r":8,"matrix_dimensions_u":5,"start_bv_ind":1,"start_bv_r_ind":7,"start_bv_u_ind":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void assemble_bv(global float* g_bv_r, global float* g_bv, unsigned int col_n) {
  for (unsigned int i = 0; i < col_n; ++i) {
    g_bv_r[hook(6, i)] = g_bv[hook(0, i)];
  }
}

void assemble_bv_block(global float* g_bv_r, global float* g_bv, unsigned int col_n, global float* g_bv_u, unsigned int col_n_u) {
  assemble_bv(g_bv_r, g_bv, col_n);
  assemble_bv(g_bv_r + col_n, g_bv_u, col_n_u);
}

kernel void block_bv_assembly(global float* g_bv, global unsigned int* start_bv_ind, global unsigned int* matrix_dimensions, global float* g_bv_u, global unsigned int* start_bv_u_ind, global unsigned int* matrix_dimensions_u, global float* g_bv_r, global unsigned int* start_bv_r_ind, global unsigned int* matrix_dimensions_r, global unsigned int* g_is_update,

                              unsigned int block_elems_num) {
  for (unsigned int i = get_global_id(0); i < block_elems_num; i += get_global_size(0)) {
    if ((matrix_dimensions[hook(2, 2 * i)] > 0) && (matrix_dimensions[hook(2, 2 * i + 1)] > 0) && g_is_update[hook(9, i)] > 0) {
      assemble_bv_block(g_bv_r + start_bv_r_ind[hook(7, i)], g_bv + start_bv_ind[hook(1, i)], matrix_dimensions[hook(2, 2 * i + 1)], g_bv_u + start_bv_u_ind[hook(4, i)], matrix_dimensions_u[hook(5, 2 * i + 1)]);
    }
  }
}