//{"a":2,"inputImage":0,"outputImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void img_trans(global uchar4* inputImage, global uchar4* outputImage) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  unsigned int width = get_global_size(0);
  unsigned int height = get_global_size(1);

  int c = x + y * width;

  float4 a[9];

  if (x >= 1 && x < (width - 1) && y >= 1 && y < height - 1) {
    a[hook(2, 0)] = convert_float4(inputImage[hook(0, c - 1 - width)]);
    a[hook(2, 1)] = convert_float4(inputImage[hook(0, c - width)]);
    a[hook(2, 2)] = convert_float4(inputImage[hook(0, c + 1 - width)]);
    a[hook(2, 3)] = convert_float4(inputImage[hook(0, c - 1)]);
    a[hook(2, 4)] = convert_float4(inputImage[hook(0, c)]);
    a[hook(2, 5)] = convert_float4(inputImage[hook(0, c + 1)]);
    a[hook(2, 6)] = convert_float4(inputImage[hook(0, c - 1 + width)]);
    a[hook(2, 7)] = convert_float4(inputImage[hook(0, c + width)]);
    a[hook(2, 8)] = convert_float4(inputImage[hook(0, c + 1 + width)]);

    float4 minVal = (float4)(255);

    for (int i = 0; i < 9; i++) {
      minVal = min(minVal, a[hook(2, i)]);
    }

    outputImage[hook(1, c)] = convert_uchar4(minVal);
  }
}