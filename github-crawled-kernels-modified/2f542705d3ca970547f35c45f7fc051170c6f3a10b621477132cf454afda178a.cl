//{"d_output":2,"imageH":4,"imageW":3,"volume":0,"volumeSampler":1,"w":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void render(read_only image3d_t volume, sampler_t volumeSampler, global unsigned int* d_output, unsigned int imageW, unsigned int imageH, float w) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  float u = x / (float)imageW;
  float v = y / (float)imageH;

  float4 voxel = read_imagef(volume, volumeSampler, (float4)(u, v, w, 1.0f));

  if ((x < imageW) && (y < imageH)) {
    unsigned int i = (y * imageW) + x;
    d_output[hook(2, i)] = voxel.x * 255;
  }
}