//{"mask_size":2,"origo_x":3,"origo_y":4,"origo_z":5,"pixel_pos":0,"volume_spacing":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void round_off_translate(global float* pixel_pos, float volume_spacing, int mask_size, float origo_x, float origo_y, float origo_z) {
  int n = get_global_id(0);
  if (n >= mask_size)
    return;

  (pixel_pos[hook(0, (n) * 3 + (0))]) = (int)((pixel_pos[hook(0, (n) * 3 + (0))]) / volume_spacing) - origo_x;
  (pixel_pos[hook(0, (n) * 3 + (1))]) = (int)((pixel_pos[hook(0, (n) * 3 + (1))]) / volume_spacing) - origo_y;
  (pixel_pos[hook(0, (n) * 3 + (2))]) = (int)((pixel_pos[hook(0, (n) * 3 + (2))]) / volume_spacing) - origo_z;
}