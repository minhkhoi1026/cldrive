//{"covmat_in":0,"covmat_out":1,"dimension":2,"gauss":8,"height_overlap":3,"local_data":7,"scale_size":5,"scale_size_max":6,"width_overlap":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void covmat_spatial_avg(global float* covmat_in, global float* covmat_out, const int dimension, const int height_overlap, const int width_overlap, const int scale_size, const int scale_size_max, local float* local_data, constant float* gauss) {
  const int delta_scale = (scale_size_max - scale_size) / 2;

  const int block_size = get_local_size(0);
  const int output_block_size = get_local_size(0) - scale_size + 1;

  const int tx = get_local_id(0);
  const int ty = get_local_id(1);

  const int in_x = get_group_id(0) * output_block_size + tx;
  const int in_y = get_group_id(1) * output_block_size + ty;

  const int height_overlap_avg = height_overlap + scale_size_max - 1;
  const int width_overlap_avg = width_overlap + scale_size_max - 1;

  for (int i = 0; i < 2 * dimension * dimension; i++) {
    if ((in_x < height_overlap_avg) && (in_y < width_overlap_avg)) {
      local_data[hook(7, tx * block_size + ty)] = covmat_in[hook(0, i * height_overlap_avg * width_overlap_avg + (delta_scale + in_x) * width_overlap_avg + delta_scale + in_y)];
    }

    barrier(0x01);

    float sum = 0;

    if ((tx < output_block_size) && (ty < output_block_size)) {
      for (int kx = 0; kx < scale_size; kx++) {
        for (int ky = 0; ky < scale_size; ky++) {
          sum += gauss[hook(8, kx * scale_size + ky)] * local_data[hook(7, (tx + kx) * block_size + ty + ky)];
        }
      }
      if (in_x < height_overlap && in_y < width_overlap) {
        covmat_out[hook(1, i * height_overlap * width_overlap + in_x * width_overlap + in_y)] = sum;
      }
    }
  }
}