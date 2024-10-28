//{"height":3,"inputImage":0,"outputImage":1,"width":2,"x_w":4,"y_w":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sobel_filter(global uchar4* inputImage, global uchar4* outputImage, unsigned int width, unsigned int height, int x_w, int y_w) {
  unsigned int x = (get_global_id(0) + x_w);
  unsigned int y = (get_global_id(1) + y_w);

  float4 Gx = (float4)(0);
  float4 Gy = Gx;

  int c = x + y * width;

  if (x >= 1 && x < (width - 1) && y >= 1 && y < height - 1) {
    float4 i00 = convert_float4(inputImage[hook(0, c - 1 - width)]);
    float4 i10 = convert_float4(inputImage[hook(0, c - width)]);
    float4 i20 = convert_float4(inputImage[hook(0, c + 1 - width)]);
    float4 i01 = convert_float4(inputImage[hook(0, c - 1)]);
    float4 i11 = convert_float4(inputImage[hook(0, c)]);
    float4 i21 = convert_float4(inputImage[hook(0, c + 1)]);
    float4 i02 = convert_float4(inputImage[hook(0, c - 1 + width)]);
    float4 i12 = convert_float4(inputImage[hook(0, c + width)]);
    float4 i22 = convert_float4(inputImage[hook(0, c + 1 + width)]);

    Gx = i00 + (float4)(2) * i10 + i20 - i02 - (float4)(2) * i12 - i22;

    Gy = i00 - i20 + (float4)(2) * i01 - (float4)(2) * i21 + i02 - i22;

    outputImage[hook(1, c)] = convert_uchar4(hypot(Gx, Gy) / (float4)(2));
  }
}