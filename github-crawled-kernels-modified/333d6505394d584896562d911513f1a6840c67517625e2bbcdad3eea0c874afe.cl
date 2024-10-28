//{"mask_size":2,"pixel_ill":1,"pixel_pos":0,"volume":3,"volume_h":5,"volume_n":4,"volume_w":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill_volume(global float* pixel_pos, global unsigned char* pixel_ill, int mask_size, global unsigned char* volume, int volume_n, int volume_h, int volume_w) {
  int n = get_global_id(0);
  if (n >= mask_size)
    return;

  int x = (pixel_pos[hook(0, (n) * 3 + (0))]);
  int y = (pixel_pos[hook(0, (n) * 3 + (1))]);
  int z = (pixel_pos[hook(0, (n) * 3 + (2))]);
  if (((x) >= (0) && (x) <= (volume_w)) && ((y) >= (0) && (y) <= (volume_h)) && ((z) >= (0) && (z) <= (volume_n)))
    (volume[hook(3, (x) + (y) * volume_w + (z) * volume_w * volume_h)]) = pixel_ill[hook(1, n)];
}