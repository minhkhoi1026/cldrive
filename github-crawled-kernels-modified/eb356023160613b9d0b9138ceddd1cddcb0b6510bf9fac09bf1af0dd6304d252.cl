//{"image_height":1,"image_width":0,"inverse_image":5,"local_radius":2,"output_image":6,"x_derivatives":3,"y_derivatives":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void timm_and_barth(int image_width, int image_height, int local_radius, global float* x_derivatives, global float* y_derivatives, global float* inverse_image, global float* output_image) {
  size_t gid = get_global_id(0);
  size_t numpixels = image_width * image_height;

  int center_x = ((gid) / image_height);
  int center_y = ((gid) % image_height);

  float accumul = .0f;

  for (size_t point_x = (center_x - local_radius > 0 ? center_x - local_radius : 0); point_x < image_width && point_x < center_x + local_radius; point_x++) {
    for (size_t point_y = (center_y - local_radius > 0 ? center_y - local_radius : 0); point_y < image_height && point_y < center_y + local_radius; point_y++) {
      size_t pixelid = ((point_y) + ((point_x)*image_height));
      float displac_x = (float)(point_x - center_x);
      float displac_y = (float)(point_y - center_y);
      float displac_norm = sqrt(displac_x * displac_x + displac_y * displac_y) + 0.00001;
      if (displac_norm > local_radius) {
        continue;
      }

      displac_x = displac_x / displac_norm;
      displac_y = displac_y / displac_norm;

      float dotprod = displac_x * x_derivatives[hook(3, pixelid)] + displac_y * y_derivatives[hook(4, pixelid)];
      if (dotprod > 0) {
        accumul += (dotprod * dotprod) * inverse_image[hook(5, gid)];
      }
    }
  }

  output_image[hook(6, gid)] = accumul / (float)numpixels;
}