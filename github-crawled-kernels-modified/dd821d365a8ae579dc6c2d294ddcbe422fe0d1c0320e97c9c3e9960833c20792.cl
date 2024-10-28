//{"image":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void write_image(global char* output, write_only image2d_t image) {
  write_imagei(image, (int2)(0, 0), (int4)(1, 2, 3, 4));

  write_imageui(image, (int2)(0, 0), (uint4)(1, 2, 3, 4));

  write_imagef(image, (int2)(0, 0), (float4)(1, 2, 3, 4));

  for (int y = 0; y < 10; ++y) {
    for (int x = 0; x < 10; ++x) {
      write_imagef(image, (int2)(x, y), (float4)(x, y, 3, 4));
    }
  }

  for (int y = 10; y < 10000; ++y) {
    for (int x = 10; x < 1000; ++x) {
      write_imagef(image, (int2)(x, y), (float4)(x, y, 3, 4));
    }
  }

  for (int y = -10; y > -10000; --y) {
    for (int x = -10; x > -1000; --x) {
      write_imagef(image, (int2)(x, y), (float4)(x, y, 3, 4));
    }
  }
}