//{"height_unpacked":4,"interf_imag_packed":3,"interf_imag_unpacked":1,"interf_real_packed":2,"interf_real_unpacked":0,"offset_x":8,"offset_y":9,"overlap":7,"patch_size":6,"width_unpacked":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void patches_pack(global float* interf_real_unpacked, global float* interf_imag_unpacked, global float* interf_real_packed, global float* interf_imag_packed, const int height_unpacked, const int width_unpacked, const int patch_size, const int overlap, const int offset_x, const int offset_y) {
  const int width_packed = width_unpacked / patch_size * (patch_size - 2 * overlap);
  const int height_packed = height_unpacked / patch_size * (patch_size - 2 * overlap);

  const int tx = get_global_id(0);
  const int ty = get_global_id(1);

  const int patch_idx = 2 * (tx / patch_size) + offset_x / patch_size;
  const int patch_idy = 2 * (ty / patch_size) + offset_y / patch_size;

  const int rel_tx = tx % patch_size;
  const int rel_ty = ty % patch_size;

  const int in_idx = patch_idx * patch_size + rel_tx;
  const int in_idy = patch_idy * patch_size + rel_ty;

  const int out_idx = patch_idx * (patch_size - 2 * overlap) + (rel_tx - overlap);
  const int out_idy = patch_idy * (patch_size - 2 * overlap) + (rel_ty - overlap);

  float scaling_factor = 1.0f;
  if (rel_tx < 2 * overlap || rel_tx >= patch_size - 2 * overlap) {
    scaling_factor *= 0.5f;
  }
  if (rel_ty < 2 * overlap || rel_ty >= patch_size - 2 * overlap) {
    scaling_factor *= 0.5f;
  }
  if (out_idx < overlap || out_idx >= width_packed - overlap) {
    scaling_factor *= 2.0f;
  }
  if (out_idy < overlap || out_idy >= height_packed - overlap) {
    scaling_factor *= 2.0f;
  }

  const float val_real = scaling_factor * interf_real_unpacked[hook(0, in_idy * width_unpacked + in_idx)];
  const float val_imag = scaling_factor * interf_imag_unpacked[hook(1, in_idy * width_unpacked + in_idx)];

  if (out_idx >= 0 && out_idx < width_packed && out_idy >= 0 && out_idy < height_packed) {
    interf_real_packed[hook(2, out_idy * width_packed + out_idx)] += val_real;
    interf_imag_packed[hook(3, out_idy * width_packed + out_idx)] += val_imag;
  }
}