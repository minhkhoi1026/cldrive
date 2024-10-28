//{"halflen":3,"imgConvolved":1,"imgSrc":0,"kernelValues":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve1d_naive(read_only image2d_t imgSrc, write_only image2d_t imgConvolved, constant float* kernelValues, int halflen) {
  int i = get_global_id(1);
  int ii = i + halflen;

  float4 convPix = read_imagef(imgSrc, (int2)(0, ii)) * kernelValues[hook(2, halflen)];

  for (int k = 1; k <= halflen; k++) {
    convPix += read_imagef(imgSrc, (int2)(0, ii + k)) * kernelValues[hook(2, halflen - k)] + read_imagef(imgSrc, (int2)(0, ii - k)) * kernelValues[hook(2, halflen + k)];
  }
  write_imagef(imgConvolved, (int2)(0, i), convPix);
}