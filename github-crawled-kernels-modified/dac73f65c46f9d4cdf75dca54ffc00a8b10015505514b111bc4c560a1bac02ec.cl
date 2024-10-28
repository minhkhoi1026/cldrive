//{"cache":7,"height_sim":2,"patch_similarities":1,"patch_size":4,"patch_size_max":5,"pixel_similarities":0,"pixel_similarities_local":6,"width_sim":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_patch_similarities(global float* pixel_similarities, global float* patch_similarities, const int height_sim, const int width_sim, const int patch_size, const int patch_size_max, local float* pixel_similarities_local, local float* cache) {
  const int offset = (patch_size_max - patch_size) / 2;

  const int height_ori = height_sim - patch_size_max + 1;
  const int width_ori = width_sim - patch_size_max + 1;

  const int output_block_size = get_local_size(0) - patch_size + 1;

  const int tx = get_local_id(0);
  const int ty = get_local_id(1);
  const int tz = get_global_id(2);

  const int out_x = get_group_id(0) * output_block_size + tx;
  const int out_y = get_group_id(1) * output_block_size + ty;

  if ((out_x < height_sim) && (out_y < width_sim)) {
    pixel_similarities_local[hook(6, tx * get_local_size(1) + ty)] = pixel_similarities[hook(0, tz * height_sim * width_sim + (offset + out_x) * width_sim + offset + out_y)];
  } else {
    pixel_similarities_local[hook(6, tx * get_local_size(1) + ty)] = 0;
  }

  barrier(0x01);

  float sum = 0;

  if (ty < output_block_size) {
    for (int ky = 0; ky < patch_size; ky++) {
      sum += pixel_similarities_local[hook(6, tx * get_local_size(1) + ty + ky)];
    }
    cache[hook(7, tx * output_block_size + ty)] = sum;
  }

  barrier(0x01);
  if (tx < output_block_size) {
    for (int kx = 1; kx < patch_size; kx++) {
      sum += cache[hook(7, (tx + kx) * output_block_size + ty)];
    }
  }

  if ((tx < output_block_size) && (ty < output_block_size)) {
    if (out_x < height_ori && out_y < width_ori) {
      patch_similarities[hook(1, tz * height_ori * width_ori + out_x * width_ori + out_y)] = sum;
    }
  }
}