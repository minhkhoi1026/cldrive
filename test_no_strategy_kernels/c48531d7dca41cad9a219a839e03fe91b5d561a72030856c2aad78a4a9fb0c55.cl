//{"image":3,"image_height":1,"image_width":0,"nbins":2,"output_Q":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lsh_Q(unsigned int image_width, unsigned int image_height, uchar nbins, global float* image, global float* output_Q) {
  size_t gid = get_global_id(0);
  float intensity = image[hook(3, gid)];

  uchar bin_number = floor(intensity * nbins);

  output_Q[hook(4, ((bin_number) + ((((gid) % image_width)) * nbins) + ((((gid) / image_width)) * image_width * nbins)))] = 1.0;
}