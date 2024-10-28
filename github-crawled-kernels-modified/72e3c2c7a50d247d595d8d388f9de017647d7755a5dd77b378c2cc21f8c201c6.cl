//{"ImageHeight":4,"ImageWidth":3,"Offset":1,"OffsetNext":2,"maskSize":6,"sigma":5,"ucSource":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckConv(global float* ucSource, int Offset, int OffsetNext, int ImageWidth, int ImageHeight, float sigma, int maskSize) {
  int pozX = 0;
  int pozY = 0;
  float pi = 3.1415926535897932384626433832795;
  int r = 0;
  float sum = 0.0;
  float sumG = 0.0;
  float G = 0.0;
  int punktOffset = 0;

  pozX = get_global_id(0) > ImageWidth ? ImageWidth : get_global_id(0);
  pozY = get_global_id(1) > ImageHeight ? ImageHeight : get_global_id(1);

  punktOffset = OffsetNext + mul24(pozY, ImageWidth) + pozX;

  r = (int)floor((float)maskSize / 2);

  for (int j = -r; j <= r; j++) {
    for (int ii = -r; ii <= r; ii++) {
      G = exp((float)((-1.0) * (float)((float)ii * (float)ii + (float)j * (float)j) / (2.0 * sigma * sigma)));
      sumG += G;
      int x = pozX + ii >= 0 && pozX + ii <= ImageWidth ? pozX + ii : 0;
      int y = pozY + j >= 0 && pozY + j <= ImageHeight ? pozY + j : 0;

      int offset = Offset + mul24(y, ImageWidth) + x;
      sum += G * ucSource[hook(0, offset)];
    }
  }

  if ((pozY <= ImageHeight) && (pozX <= ImageWidth)) {
    ucSource[hook(0, punktOffset)] = sum / (2.0 * pi * sigma * sigma);
  }
}