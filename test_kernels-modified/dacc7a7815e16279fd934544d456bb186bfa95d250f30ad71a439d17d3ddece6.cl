//{"image0":0,"image1":1,"resultArray":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
kernel void ssd(read_only image2d_t image0, read_only image2d_t image1, global float* resultArray, int width) {
  int y = get_global_id(0);

  float sum = 0;

  for (int i = 0; i < width; i++) {
    int2 coords = {i, y};
    float value0 = read_imagef(image0, sampler, coords).x;
    float value1 = read_imagef(image1, sampler, coords).x;
    float diff = value0 - value1;
    sum += diff * diff;
  }

  resultArray[hook(2, y)] = sum;
}