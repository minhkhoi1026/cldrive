//{"filter":1,"filter_width":7,"fwork":4,"image":0,"image_height":6,"image_width":5,"num_filters":8,"result":2,"scratch":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve2d(global unsigned char* image, global float* filter, global unsigned char* result, local float* scratch, local float* fwork, unsigned long image_width, unsigned long image_height, unsigned int filter_width, unsigned int num_filters) {
  const unsigned int pixel = get_global_id(0);
  const unsigned int fid = get_global_id(1);
  const unsigned int fchunk = get_global_id(2);

  const unsigned int lid = get_local_id(2);
  const unsigned int local_size = get_local_size(2);

  const unsigned int filter_len = filter_width * filter_width;
  const unsigned int image_size = image_width * image_height;
  const unsigned int chunk_size = filter_len < local_size ? filter_len : filter_len / local_size;

  const unsigned int start = chunk_size * lid;
  unsigned int end = start + chunk_size;

  if (filter_len % local_size != 0 && fchunk == local_size - 1) {
    end = filter_len;
  }
  scratch[hook(3, lid)] = 0.0;

  for (unsigned int i = start; i < end && i < filter_len; ++i) {
    fwork[hook(4, i)] = filter[hook(1, i + fid * filter_len)];
  }
  barrier(0x01);

  if (pixel < (image_width * image_height) && fid < num_filters) {
    const int px = pixel % image_width;
    const int py = ((pixel - px) / image_width);
    const int offset = (filter_len - 1) / 2;

    const int cornerx = px - offset;
    const int cornery = py - offset;

    float sum = 0.0f;

    for (unsigned int i = start; i < end && i < filter_len; ++i) {
      int col = (cornerx) + (i % filter_width);
      int row = (cornery) + ((i - (i % filter_width)) / filter_width);

      float source;
      if (row < 0 || row > image_height || col < 0 || col > image_width) {
        source = 0.0f;
      } else {
        source = image[hook(0, row * image_width + col)];
      }

      const unsigned int findex = filter_len - i - 1;
      const float weight = fwork[hook(4, findex)];
      sum += source * weight;
    }
    scratch[hook(3, lid)] = sum;
  }
  barrier(0x01);

  for (unsigned int offset = local_size / 2; offset > 0; offset >>= 1) {
    if (lid < offset) {
      const float other = scratch[hook(3, lid + offset)];
      scratch[hook(3, lid)] += other;
    }
    barrier(0x01);
  }

  if (lid == 0) {
    result[hook(2, pixel + fid * image_size)] = scratch[hook(3, 0)];
  }
}