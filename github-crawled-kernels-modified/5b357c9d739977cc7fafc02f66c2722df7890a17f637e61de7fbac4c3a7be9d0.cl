//{"filter":1,"filter_height":6,"filter_width":5,"image":0,"image_height":4,"image_width":3,"num_filters":7,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve2d(constant unsigned char* image, constant float* filter, global unsigned char* result, unsigned int image_width, unsigned int image_height, unsigned long filter_width, unsigned long filter_height, unsigned int num_filters) {
  int pixel = get_global_id(0);
  int fid = get_global_id(1);

  if (pixel < (image_width * image_height) && fid < num_filters) {
    const int px = pixel % image_width;
    const int py = ((pixel - px) / image_width);
    const unsigned int image_size = image_width * image_height;
    const unsigned long filter_len = filter_width * filter_height;
    const int offset = (filter_len - 1) / 2;

    const int cornerx = px - offset;
    const int cornery = py - offset;

    float sum = 0;

    for (unsigned int i = 0; i < filter_len; ++i) {
      int col = (cornerx) + (i % filter_width);
      int row = (cornery) + ((i - (i % filter_width)) / filter_width);

      float source;
      if (row < 0 || row > image_height || col < 0 || col > image_width) {
        source = 0;
      } else {
        source = image[hook(0, row * image_width + col)];
      }

      const unsigned int findex = filter_len - i - 1 + fid * filter_len;
      const float weight = filter[hook(1, findex)];
      sum += source * weight;
    }
    result[hook(2, py * image_width + px + fid * image_size)] = sum;
  }
}