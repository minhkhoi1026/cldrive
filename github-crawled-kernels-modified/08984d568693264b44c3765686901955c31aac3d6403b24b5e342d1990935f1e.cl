//{"gamma":4,"image":0,"rgbabuffer":1,"vmax":3,"vmin":2,"zmax":6,"zmin":5,"zstep":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buffer_render_maxproj_3df(global float* image, global uchar* rgbabuffer, float vmin, float vmax, float gamma, int zmin, int zmax, int zstep) {
  const int width = get_global_size(0);
  const int height = get_global_size(1);
  const int depth = get_global_size(2);

  const int x = get_global_id(0);
  const int y = get_global_id(1);

  zmin = max(0, zmin);
  zmax = min(depth, zmax);

  float acc = 0;
  for (int z = zmin; z < zmax;) {
    for (int i = 0; i < 8; i++) {
      const unsigned int i = x + width * y + width * height * z;
      const float value = image[hook(0, i)];
      acc = fmax(acc, value);
      z += zstep;
    }
  }

  const float value = clamp(native_powr((acc - vmin) / (vmax - vmin), gamma), 0.0f, 1.0f);

  const int i = x + width * y;
  const uchar bytevalue = (uchar)(255 * value);

  vstore4((uchar4){bytevalue, bytevalue, bytevalue, 255}, i, rgbabuffer);
}