//{"datacost":2,"dispRange":5,"height":4,"left":0,"mSize":6,"right":1,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int index_y(int y, int height) {
  if (0 <= y && y < height)
    return y;
  else if (y < 0)
    return 0;
  else
    return height - 1;
}

int index_x(int x, int width) {
  if (0 <= x && x < width)
    return x;
  else if (x < 0)
    return 0;
  else
    return width - 1;
}

kernel void ASW_Disparity(global uchar* left, global uchar* right, global float* datacost, int width, int height, int dispRange, int mSize) {
  int j = get_global_id(0);
  int i = get_global_id(1);
  int k = get_global_id(2);

  const float sigmaColor = 10.0f;
  const float sigmaSpatial = mSize * 1.5f;
  const float truncation = 25.0f;
  float spatialDiff, colorDiff, weightL, weightR;
  if (j - k >= 0) {
    float diff = 0;
    float temp_diff = 0;
    float weight = 0;
    for (int m = -mSize; m <= mSize; m++) {
      for (int n = -mSize; n <= mSize; n++) {
        int x1 = j + n;
        int x2 = j + n - k;
        int y = i + m;

        y = index_y(y, height);
        x1 = index_x(x1, width);
        x2 = index_x(x2, width);

        spatialDiff = hypot((float)m, (float)n);

        colorDiff = sqrt((float)(left[hook(0, y * width + x1)] - left[hook(0, i * width + j)]) * (float)(left[hook(0, y * width + x1)] - left[hook(0, i * width + j)]));
        weightL = exp(-1.0f * ((colorDiff / sigmaColor) + (spatialDiff / sigmaSpatial)));

        colorDiff = sqrt((float)(right[hook(1, y * width + x2)] - right[hook(1, i * width + j - k)]) * (float)(right[hook(1, y * width + x2)] - right[hook(1, i * width + j - k)]));
        weightR = exp(-1.0f * ((colorDiff / sigmaColor) + (spatialDiff / sigmaSpatial)));

        temp_diff = fabs((float)(left[hook(0, y * width + x1)] - right[hook(1, y * width + x2)]));
        if (temp_diff > truncation)
          temp_diff = truncation;

        diff += temp_diff * weightL * weightR / 255.0f;
        weight += weightL * weightR;
      }
    }

    datacost[hook(2, dispRange * (width * i + j) + k)] = diff / weight;
  } else {
    datacost[hook(2, dispRange * (width * i + j) + k)] = 1000.0f;
  }
}