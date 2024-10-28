//{"N":2,"inputImage":0,"outputImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void box_filter(global uint4* inputImage, global uchar4* outputImage, unsigned int N) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);
  int k = (N - 1) / 2;

  if (x < k || y < k || x > width - k - 1 || y > height - k - 1) {
    outputImage[hook(1, x + y * width)] = (uchar4)(0);
    return;
  }

  int4 filterSize = (int4)(N * N);

  int2 posA = (int2)(x - k, y - k);
  int2 posB = (int2)(x + k, y - k);
  int2 posC = (int2)(x + k, y + k);
  int2 posD = (int2)(x - k, y + k);

  int4 sumA = (int4)(0);
  int4 sumB = (int4)(0);
  int4 sumC = (int4)(0);
  int4 sumD = (int4)(0);

  posA.x -= 1;
  posA.y -= 1;
  posB.y -= 1;
  posD.x -= 1;

  if (posA.x >= 0 && posA.y >= 0) {
    sumA = convert_int4(inputImage[hook(0, posA.x + posA.y * width)]);
  }
  if (posB.x >= 0 && posB.y >= 0) {
    sumB = convert_int4(inputImage[hook(0, posB.x + posB.y * width)]);
  }
  if (posD.x >= 0 && posD.y >= 0) {
    sumD = convert_int4(inputImage[hook(0, posD.x + posD.y * width)]);
  }
  sumC = convert_int4(inputImage[hook(0, posC.x + posC.y * width)]);

  outputImage[hook(1, x + y * width)] = convert_uchar4((sumA + sumC - sumB - sumD) / filterSize);
}