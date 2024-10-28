//{"batch_size":0,"dest":2,"source":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler_const = 0 | 0 | 0x10;
kernel void rgb2gray_patches(const int batch_size, read_only image2d_t source, write_only image2d_t dest) {
  const int2 group = (int2)(batch_size, batch_size);
  const int2 base = (int2)(get_global_id(0) * group.x, get_global_id(1) * group.y);

  for (int i = 0; i < group.x; i++) {
    for (int j = 0; j < group.y; j++) {
      const int2 loco = base + (int2)(i, j);
      const float4 rgba = read_imagef(source, sampler_const, loco);
      const float gray = 0.2126 * rgba.x + 0.7152 * rgba.y + 0.0722 * rgba.z;
      write_imagef(dest, loco, (float4)(gray, gray, gray, 1.0));
    }
  }
}