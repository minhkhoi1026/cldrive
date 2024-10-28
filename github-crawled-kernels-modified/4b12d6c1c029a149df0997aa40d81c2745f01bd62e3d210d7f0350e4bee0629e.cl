//{"d_data":1,"d_index":2,"d_perm":3,"dim":5,"dst_vector":0,"jds_ptr_int":6,"sh_zcnt_int":7,"x_vec":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmv_jds_texture(global float* dst_vector, global float* d_data, global int* d_index, global int* d_perm, read_only image2d_t x_vec, const int dim, constant int* jds_ptr_int, constant int* sh_zcnt_int) {
  sampler_t sampler = 0 | 0 | 0x10;
  int imgWidth = get_image_width(x_vec);

  int ix = get_global_id(0);
  int warp_id = ix >> 5;

  if (ix < dim) {
    float sum = 0.0f;
    int pt = d_perm[hook(3, ix)];
    int bound = sh_zcnt_int[hook(7, warp_id)];

    int j = jds_ptr_int[hook(6, 0)] + ix;
    float d = d_data[hook(1, j)];
    int2 i;
    i.x = d_index[hook(2, j)] % imgWidth;
    i.y = d_index[hook(2, j)] / imgWidth;

    float4 t = read_imagef(x_vec, sampler, i);

    if (bound > 1) {
      j = jds_ptr_int[hook(6, 1)] + ix;
      i.x = d_index[hook(2, j)] % imgWidth;
      i.y = d_index[hook(2, j)] / imgWidth;

      int in;
      float dn;
      float4 tn;

      for (int k = 2; k < bound; k++) {
        dn = d_data[hook(1, j)];

        j = jds_ptr_int[hook(6, k)] + ix;

        tn = read_imagef(x_vec, sampler, i);

        sum += d * t.x;

        i.x = d_index[hook(2, j)] % imgWidth;
        i.y = d_index[hook(2, j)] / imgWidth;

        d = dn;
        t = tn;
      }

      dn = d_data[hook(1, j)];

      tn = read_imagef(x_vec, sampler, i);

      sum += d * t.x;

      d = dn;
      t = tn;
    }

    sum += d * t.x;

    dst_vector[hook(0, pt)] = sum;
  }
}