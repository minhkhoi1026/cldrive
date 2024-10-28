//{"F":5,"Q":4,"alpha":3,"histogram_buffer":6,"histogram_out":8,"image_height":1,"image_width":0,"nbins":2,"normalization_buffer":7,"normalization_out":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lsh_1D_y(int image_width, int image_height, int nbins, float alpha, global float* Q, global float* F, local float* histogram_buffer, local float* normalization_buffer, global float* histogram_out, global float* normalization_out) {
  size_t colid = get_global_id(0);
  size_t worker_id = get_local_id(0);

  for (int bin = 0; bin < nbins; bin++) {
    histogram_buffer[hook(6, ((0) + (image_height * (0)) + (2 * image_height * worker_id)))] = Q[hook(4, ((bin) + ((colid) * nbins) + ((0) * image_width * nbins)))];
    normalization_buffer[hook(7, ((0) + (image_height * (0)) + (2 * image_height * worker_id)))] = F[hook(5, ((bin) + ((colid) * nbins) + ((0) * image_width * nbins)))];

    for (int y = 1; y < image_height; y++) {
      size_t pixelid = ((bin) + ((colid)*nbins) + ((y)*image_width * nbins));

      histogram_buffer[hook(6, ((y) + (image_height * (0)) + (2 * image_height * worker_id)))] = Q[hook(4, pixelid)] + alpha * histogram_buffer[hook(6, ((y - 1) + (image_height * (0)) + (2 * image_height * worker_id)))];
      normalization_buffer[hook(7, ((y) + (image_height * (0)) + (2 * image_height * worker_id)))] = F[hook(5, pixelid)] + alpha * normalization_buffer[hook(7, ((y - 1) + (image_height * (0)) + (2 * image_height * worker_id)))];
    }

    histogram_buffer[hook(6, ((image_height - 1) + (image_height * (1)) + (2 * image_height * worker_id)))] = Q[hook(4, ((bin) + ((colid) * nbins) + ((image_height - 1) * image_width * nbins)))];
    normalization_buffer[hook(7, ((image_height - 1) + (image_height * (1)) + (2 * image_height * worker_id)))] = F[hook(5, ((bin) + ((colid) * nbins) + ((image_height - 1) * image_width * nbins)))];

    for (int y2 = 0; y2 < image_height - 1; y2++) {
      int y = (image_height - 2) - y2;
      size_t pixelid = ((bin) + ((colid)*nbins) + ((y)*image_width * nbins));

      histogram_buffer[hook(6, ((y) + (image_height * (1)) + (2 * image_height * worker_id)))] = Q[hook(4, pixelid)] + alpha * histogram_buffer[hook(6, ((y + 1) + (image_height * (1)) + (2 * image_height * worker_id)))];
      normalization_buffer[hook(7, ((y) + (image_height * (1)) + (2 * image_height * worker_id)))] = F[hook(5, pixelid)] + alpha * normalization_buffer[hook(7, ((y + 1) + (image_height * (1)) + (2 * image_height * worker_id)))];
    }

    for (int y = 0; y < image_height; y++) {
      size_t pixelid = ((bin) + ((colid)*nbins) + ((y)*image_width * nbins));

      histogram_out[hook(8, pixelid)] = histogram_buffer[hook(6, ((y) + (image_height * (0)) + (2 * image_height * worker_id)))] + histogram_buffer[hook(6, ((y) + (image_height * (1)) + (2 * image_height * worker_id)))] - Q[hook(4, pixelid)];
      normalization_out[hook(9, pixelid)] = normalization_buffer[hook(7, ((y) + (image_height * (0)) + (2 * image_height * worker_id)))] + normalization_buffer[hook(7, ((y) + (image_height * (1)) + (2 * image_height * worker_id)))] - 1.0;
    }
  }
}