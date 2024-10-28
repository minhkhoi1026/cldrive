//{"d_data":1,"d_index":2,"d_perm":3,"dim":5,"dst_vector":0,"jds_ptr_int":6,"sh_zcnt_int":7,"x_vec":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmv_jds(global float* dst_vector, global float* d_data, global int* d_index, global int* d_perm, global float* x_vec, const int dim, constant int* jds_ptr_int, constant int* sh_zcnt_int) {
  int ix = get_global_id(0);
  int warp_id = ix >> 5;

  if (ix < dim) {
    float sum = 0.0f;
    int bound = sh_zcnt_int[hook(7, warp_id)];

    int j = jds_ptr_int[hook(6, 0)] + ix;
    float d = d_data[hook(1, j)];
    int i = d_index[hook(2, j)];
    float t = x_vec[hook(4, i)];

    if (bound > 1) {
      j = jds_ptr_int[hook(6, 1)] + ix;
      i = d_index[hook(2, j)];
      int in;
      float dn;
      float tn;
      for (int k = 2; k < bound; k++) {
        dn = d_data[hook(1, j)];

        j = jds_ptr_int[hook(6, k)] + ix;
        in = d_index[hook(2, j)];

        tn = x_vec[hook(4, i)];

        sum += d * t;

        i = in;

        d = dn;
        t = tn;
      }

      dn = d_data[hook(1, j)];
      tn = x_vec[hook(4, i)];

      sum += d * t;

      d = dn;
      t = tn;
    }

    sum += d * t;

    dst_vector[hook(0, d_perm[ihook(3, ix))] = sum;
  }
}