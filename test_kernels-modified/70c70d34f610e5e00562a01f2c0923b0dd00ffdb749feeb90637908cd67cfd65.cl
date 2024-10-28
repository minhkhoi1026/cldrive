//{"d_data":1,"d_index":2,"d_perm":3,"dim":5,"dst_vector":0,"jds_ptr_int":6,"sh_zcnt_int":7,"x_vec":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmv_jds_naive(global float* dst_vector, global float* d_data, global int* d_index, global int* d_perm, global float* x_vec, const int dim, constant int* jds_ptr_int, constant int* sh_zcnt_int) {
  int ix = get_global_id(0);

  if (ix < dim) {
    float sum = 0.0f;

    int bound = sh_zcnt_int[hook(7, ix / 32)];

    for (int k = 0; k < bound; k++) {
      int j = jds_ptr_int[hook(6, k)] + ix;
      int in = d_index[hook(2, j)];

      float d = d_data[hook(1, j)];
      float t = x_vec[hook(4, in)];

      sum += d * t;
    }

    dst_vector[hook(0, d_perm[ihook(3, ix))] = sum;
  }
}