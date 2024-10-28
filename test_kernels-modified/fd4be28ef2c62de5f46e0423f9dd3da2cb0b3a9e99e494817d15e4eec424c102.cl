//{"attribute_count":1,"buffer":5,"image":4,"instance_count":2,"mode":0,"pivot":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void multiply_matrices(global int* mode, global int* attribute_count, global int* instance_count, global int* pivot, read_only image2d_t image, global float* buffer) {
  int thread_index = get_global_id(0);

  if (thread_index < *instance_count) {
    float sum = 0.f;
    int z, width_attribute = (*attribute_count + (4 - (*attribute_count % 4))), width_pixels = width_attribute / 4, image_height = get_image_height(image), thread_column = (thread_index / image_height) * width_pixels, thread_row = thread_index % image_height;

    if (*mode == 2) {
      int pivot_column = (*pivot / image_height) * width_pixels, pivot_row = *pivot % image_height;

      for (z = 0; z < width_pixels; z++) {
        sum += dot(read_imagef(image, sampler, (int2)(pivot_column + z, pivot_row)), read_imagef(image, sampler, (int2)(thread_column + z, thread_row)));
      }
    } else if (*mode == 1) {
      for (z = 0; z < width_pixels; z++) {
        float4 pixel = read_imagef(image, sampler, (int2)(thread_column + z, thread_row));
        sum += dot(pixel, pixel);
      }
    }
    buffer[hook(5, thread_index)] = sum;
  }
}