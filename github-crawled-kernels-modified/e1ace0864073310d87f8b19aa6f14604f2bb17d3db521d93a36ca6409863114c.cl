//{"filter":1,"filter_height":7,"filter_width":6,"image":0,"image_height":5,"image_width":4,"num_filters":8,"psum":3,"scratch":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve2d(global unsigned char* image, global float* filter, local float* scratch, global float* psum, unsigned long image_width, unsigned long image_height, unsigned int filter_width, unsigned int filter_height, unsigned int num_filters) {
  const unsigned int pixel = get_global_id(0);
  const unsigned int fid = get_global_id(1);
  const unsigned int fcell = get_global_id(2);

  const unsigned int lp = get_local_id(0);
  const unsigned int lf = get_local_id(1);
  const unsigned int lc = get_local_id(2);

  const unsigned int filter_len = filter_width * filter_height;
  const unsigned int image_size = image_width * image_height;

  scratch[hook(2, lc)] = 0.0;
  barrier(0x01);

  if (pixel < image_size && fid < num_filters && fcell < filter_len) {
    const int px = pixel % image_width;
    const int py = ((pixel - px) / image_width);
    const int offset = (filter_len - 1) / 2;

    const int cornerx = px - offset;
    const int cornery = py - offset;

    const int col = (cornerx) + (fcell % filter_width);
    const int row = (cornery) + ((fcell - (fcell % filter_width)) / filter_width);

    float source;
    if (row < 0 || row > image_height || col < 0 || col > image_width) {
      source = 0;
    } else {
      source = image[hook(0, row * image_width + col)];
    }
    const unsigned int findex = filter_len - fcell - 1 + fid * filter_len;
    const float weight = filter[hook(1, findex)];
    scratch[hook(2, lc)] = source * weight;
  }
  barrier(0x01);

  for (unsigned int offset = get_local_size(2) / 2; offset > 0; offset >>= 1) {
    if (lc < offset) {
      const float other = scratch[hook(2, lc + offset)];
      scratch[hook(2, lc)] += other;
    }
    barrier(0x01);
  }

  if (lc == 0) {
    psum[hook(3, pixel - get_global_offset(0) + get_group_id(2))] = scratch[hook(2, 0)];
  }
}