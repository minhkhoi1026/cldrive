//{"height_unpacked":4,"interf_imag_packed":1,"interf_imag_unpacked":3,"interf_real_packed":0,"interf_real_unpacked":2,"overlap":7,"patch_size":6,"width_unpacked":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void patches_unpack(global float* interf_real_packed, global float* interf_imag_packed, global float* interf_real_unpacked, global float* interf_imag_unpacked, const int height_unpacked, const int width_unpacked, const int patch_size, const int overlap) {
  const int width_packed = (width_unpacked / patch_size) * (patch_size - 2 * overlap);
  const int height_packed = (height_unpacked / patch_size) * (patch_size - 2 * overlap);

  const int tx = get_global_id(0);
  const int ty = get_global_id(1);

  const int patch_idx = tx / patch_size;
  const int patch_idy = ty / patch_size;

  const int rel_tx = tx % patch_size;
  const int rel_ty = ty % patch_size;

  const int idx_packed = min(width_packed - 1, max(0, patch_idx * (patch_size - 2 * overlap) + (rel_tx - overlap)));
  const int idy_packed = min(height_packed - 1, max(0, patch_idy * (patch_size - 2 * overlap) + (rel_ty - overlap)));

  interf_real_unpacked[hook(2, ty * width_unpacked + tx)] = interf_real_packed[hook(0, idy_packed * width_packed + idx_packed)];
  interf_imag_unpacked[hook(3, ty * width_unpacked + tx)] = interf_imag_packed[hook(1, idy_packed * width_packed + idx_packed)];
}