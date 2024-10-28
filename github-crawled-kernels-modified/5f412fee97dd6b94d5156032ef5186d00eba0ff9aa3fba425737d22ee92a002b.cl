//{"filterWidth":2,"inputImage":0,"outputImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void box_filter_vertical(global uchar4* inputImage, global uchar4* outputImage, int filterWidth) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int width = get_global_size(0);
  int height = get_global_size(1);

  int pos = x + y * width;
  int k = (filterWidth - 1) / 2;

  if (y < k || y >= (height - k)) {
    outputImage[hook(1, pos)] = (uchar4)(0);
    return;
  }

  int4 size = (int4)(filterWidth);

  int4 sum = 0;

  for (int Y = -k; Y < k; Y = Y + 2) {
    sum += convert_int4(inputImage[hook(0, pos + Y * width)]);
    sum += convert_int4(inputImage[hook(0, pos + (Y + 1) * width)]);
  }
  sum += convert_int4(inputImage[hook(0, pos + k * width)]);
  outputImage[hook(1, pos)] = convert_uchar4(sum / size);
}