//{"halflen":4,"imgConvolved":1,"imgSrc":0,"kernelValues1":2,"kernelValues2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve1d2_naive(read_only image2d_t imgSrc, write_only image2d_t imgConvolved, constant float* kernelValues1, constant float* kernelValues2, int halflen) {
  int i = get_global_id(1);
  int ii = i + halflen;

  float4 temp1 = read_imagef(imgSrc, (int2)(0, ii));
  float4 temp2;
  float2 convPix1 = temp1.xy * kernelValues1[hook(2, halflen)];
  float2 convPix2 = temp1.zw * kernelValues2[hook(3, halflen)];

  for (int k = 1; k <= halflen; k++) {
    temp1 = read_imagef(imgSrc, (int2)(0, ii + k));
    temp2 = read_imagef(imgSrc, (int2)(0, ii - k));
    convPix1 += temp1.xy * kernelValues1[hook(2, halflen - k)] + temp2.xy * kernelValues1[hook(2, halflen + k)];
    convPix2 += temp1.zw * kernelValues2[hook(3, halflen - k)] + temp2.zw * kernelValues2[hook(3, halflen + k)];
  }
  write_imagef(imgConvolved, (int2)(0, i), (float4)(convPix1, convPix2));
}