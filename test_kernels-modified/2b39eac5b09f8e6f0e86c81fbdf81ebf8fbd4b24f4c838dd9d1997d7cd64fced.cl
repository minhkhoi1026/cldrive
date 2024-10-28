//{"z_buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clear_z_buffer(global int* z_buffer) {
  unsigned int z = get_global_id(0);
  unsigned int number_of_images = get_global_size(0);

  for (unsigned int x = 0; x < 512; ++x)
    for (unsigned int y = 0; y < 512; ++y) {
      unsigned int z_buffer_offset = x + y * 512 + z * 512 * 512;

      z_buffer[hook(0, z_buffer_offset)] = -1;
    }
}