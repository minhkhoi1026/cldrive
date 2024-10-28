//{"d_data":1,"d_index":2,"d_perm":3,"dim":5,"dst_vector":0,"jds_ptr_int":6,"sh_zcnt_int":7,"warp_size":8,"x_vec":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmv_jds_vec(global float* dst_vector, global float* d_data, global int* d_index, global int* d_perm, global float* x_vec, const int dim, constant int* jds_ptr_int, constant int* sh_zcnt_int, const int warp_size) {
  int mat_row = get_global_id(0);

  int j;

  float sm_value;
  int sm_index;
  float dat_value;
  if (mat_row < dim) {
    int bound = sh_zcnt_int[hook(7, mat_row / warp_size)];

    float sum = 0.0f;

    int col = 0;
    while (col < bound) {
      j = jds_ptr_int[hook(6, col)] + mat_row;
      sm_index = d_index[hook(2, j)];
      sm_value = d_data[hook(1, j)];
      dat_value = x_vec[hook(4, sm_index)];

      col += 1;
      sum += dat_value * sm_value;
    }

    dst_vector[hook(0, d_perm[mhook(3, mat_row))] = sum;
  }
}