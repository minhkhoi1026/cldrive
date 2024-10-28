//{"F":5,"Q":4,"alpha":3,"histogram_buffer":6,"histogram_out":8,"image_height":1,"image_width":0,"nbins":2,"normalization_buffer":7,"normalization_out":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lsh_1D_x(int image_width, int image_height, int nbins, float alpha, global float* Q, global float* F, local float* histogram_buffer, local float* normalization_buffer, global float* histogram_out, global float* normalization_out) {
  size_t rowid = get_global_id(0);
  size_t worker_id = get_local_id(0);

  for (int bin = 0; bin < nbins; bin++) {
    histogram_buffer[hook(6, ((0) + (image_width * (0)) + (2 * image_width * worker_id)))] = Q[hook(4, ((bin) + ((0) * nbins) + ((rowid) * image_width * nbins)))];
    normalization_buffer[hook(7, ((0) + (image_width * (0)) + (2 * image_width * worker_id)))] = F[hook(5, ((bin) + ((0) * nbins) + ((rowid) * image_width * nbins)))];

    for (int x = 1; x < image_width; x++) {
      size_t pixelid = ((bin) + ((x)*nbins) + ((rowid)*image_width * nbins));

      histogram_buffer[hook(6, ((x) + (image_width * (0)) + (2 * image_width * worker_id)))] = Q[hook(4, pixelid)] + alpha * histogram_buffer[hook(6, ((x - 1) + (image_width * (0)) + (2 * image_width * worker_id)))];
      normalization_buffer[hook(7, ((x) + (image_width * (0)) + (2 * image_width * worker_id)))] = F[hook(5, pixelid)] + alpha * normalization_buffer[hook(7, ((x - 1) + (image_width * (0)) + (2 * image_width * worker_id)))];
    }

    histogram_buffer[hook(6, ((image_width - 1) + (image_width * (1)) + (2 * image_width * worker_id)))] = Q[hook(4, ((bin) + ((image_width - 1) * nbins) + ((rowid) * image_width * nbins)))];
    normalization_buffer[hook(7, ((image_width - 1) + (image_width * (1)) + (2 * image_width * worker_id)))] = F[hook(5, ((bin) + ((image_width - 1) * nbins) + ((rowid) * image_width * nbins)))];

    for (int x2 = 0; x2 < image_width - 1; x2++) {
      int x = (image_width - 2) - x2;
      size_t pixelid = ((bin) + ((x)*nbins) + ((rowid)*image_width * nbins));

      histogram_buffer[hook(6, ((x) + (image_width * (1)) + (2 * image_width * worker_id)))] = Q[hook(4, pixelid)] + alpha * histogram_buffer[hook(6, ((x + 1) + (image_width * (1)) + (2 * image_width * worker_id)))];
      normalization_buffer[hook(7, ((x) + (image_width * (1)) + (2 * image_width * worker_id)))] = F[hook(5, pixelid)] + alpha * normalization_buffer[hook(7, ((x + 1) + (image_width * (1)) + (2 * image_width * worker_id)))];
    }

    for (int x = 0; x < image_width; x++) {
      size_t pixelid = ((bin) + ((x)*nbins) + ((rowid)*image_width * nbins));

      histogram_out[hook(8, pixelid)] = histogram_buffer[hook(6, ((x) + (image_width * (0)) + (2 * image_width * worker_id)))] + histogram_buffer[hook(6, ((x) + (image_width * (1)) + (2 * image_width * worker_id)))] - Q[hook(4, pixelid)];
      normalization_out[hook(9, pixelid)] = normalization_buffer[hook(7, ((x) + (image_width * (0)) + (2 * image_width * worker_id)))] + normalization_buffer[hook(7, ((x) + (image_width * (1)) + (2 * image_width * worker_id)))] - 1.0;
    }
  }
}