//{"imgConvolved":1,"imgSrc":0,"kernelValues":2,"w":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve2d_naive(read_only image2d_t imgSrc, write_only image2d_t imgConvolved, constant float* kernelValues, int w) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float4 convPix = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  for (int i = 0; i < w; i++) {
    for (int j = 0; j < w; j++) {
      convPix += read_imagef(imgSrc, (int2)(x + i, y + j)) * kernelValues[hook(2, i + w * j)];
    }
  }
  write_imagef(imgConvolved, (int2)(x, y), convPix);
}