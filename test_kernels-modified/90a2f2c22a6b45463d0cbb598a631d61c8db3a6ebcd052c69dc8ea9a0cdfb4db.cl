//{"image":3,"image_height":1,"image_width":0,"nbins":2,"output_binid":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void iif_binid(unsigned int image_width, unsigned int image_height, uchar nbins, global float* image, global float* output_binid) {
  size_t gid = get_global_id(0);
  float intensity = image[hook(3, gid)];

  uchar bin_number = floor(intensity * nbins);

  for (size_t b = 0; b < nbins; b++) {
    output_binid[hook(4, ((b) + ((((gid) % image_width)) * nbins) + ((((gid) / image_width)) * image_height * nbins)))] = (float)bin_number;
  }
}