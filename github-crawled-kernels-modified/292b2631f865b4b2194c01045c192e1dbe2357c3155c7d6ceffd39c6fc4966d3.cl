//{"i0":7,"i1":8,"iheight":4,"image":1,"iwidth":3,"kern":9,"out":2,"sigma_geom":5,"sigma_photo":6,"template":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float geomClose(float2 point1, float2 float2, float sigma_spatial) {
  float square = distance(point1, float2) / sigma_spatial;
  return exp(-.5f * (square * square));
}

float photomClose(float one, float two, float sigma_photo) {
  float square = (one - two) / sigma_photo;
  return exp(-.5f * (square * square));
}

float gauss(float value, float sigma) {
  float square = (value) / sigma;
  return exp(-.5f * (square * square));
}

float stddev2D(global float* image, int x, int y, float* kern, int halfWidth, int halfHeight, int iwidth, int iheight, float mean) {
  float sumWeight = 0;
  float sumFilter = 0;
  int xstep = halfWidth * 2 + 1;
  for (int j = 0; j < halfHeight * 2 + 1; j++) {
    for (int i = 0; i < xstep; i++) {
      int nx = x - halfWidth + i;
      int ny = y - halfHeight + j;
      if (nx >= 0 && nx < iwidth) {
        if (ny >= 0 && ny < iheight) {
          sumWeight += kern[hook(9, (j * xstep) + i)];
          float value = image[hook(1, nx + (ny * iwidth))] - mean;
          sumFilter += kern[hook(9, (j * xstep) + i)] * value * value;
        }
      }
    }
  }
  if (fabs(sumWeight) < 0.0001f)
    sumWeight = 1.0f;
  return sqrt(sumFilter) / sumWeight;
}

float convolution2D(global float* image, int x, int y, float* kern, int halfWidth, int halfHeight, int iwidth, int iheight) {
  float sumWeight = 0;
  float sumFilter = 0;
  int xstep = halfWidth * 2 + 1;
  for (int j = 0; j < halfHeight * 2 + 1; j++) {
    for (int i = 0; i < xstep; i++) {
      int nx = x - halfWidth + i;
      int ny = y - halfHeight + j;
      if (nx >= 0 && nx < iwidth) {
        if (ny >= 0 && ny < iheight) {
          sumWeight += kern[hook(9, (j * xstep) + i)];
          sumFilter += kern[hook(9, (j * xstep) + i)] * image[hook(1, nx + (ny * iwidth))];
        }
      }
    }
  }
  if (fabs(sumWeight) < 0.0001f)
    sumWeight = 1.0f;
  return sumFilter / sumWeight;
}

kernel void bilateralFilterPathLengthAdaptive(global float* template, global float* image, global float* out, int iwidth, int iheight, float sigma_geom, float sigma_photo, float i0, float i1) {
  int gidx = get_group_id(0);
  int gidy = get_group_id(1);
  int lidx = get_local_id(0);
  int lidy = get_local_id(1);

  int locSizex = get_local_size(0);
  int locSizey = get_local_size(1);

  int gloSizex = get_global_size(0);
  int gloSizey = get_global_size(1);

  unsigned int x = gidx * locSizex + lidx;
  unsigned int y = gidy * locSizey + lidy;

  if (x >= iwidth || y >= iheight)
    return;

  float sumWeight = 0.f;
  float sumFilter = 0.f;

  float gaussKernel[25] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};

  float meanImage = (convolution2D(image, x, y, gaussKernel, 2, 2, iwidth, iheight));

  float sigma_path = (i1) / (meanImage);

  float sigma_spatial = sigma_geom * sigma_path;

  int width = (int)(sigma_spatial * 2);
  if (width > 16)
    width = 16;
  float one = template[hook(0, x + (y * iwidth))];
  float2 current = (float2){x, y};
  for (int i = 0; i < width * 2 + 1; i++) {
    for (int j = 0; j < width * 2 + 1; j++) {
      int nx = x - width + i;
      int ny = y - width + j;
      float2 n = (float2){nx, ny};
      if (nx >= 0 && nx < iwidth) {
        if (ny >= 0 && ny < iheight) {
          float two = template[hook(0, nx + (ny * iwidth))];
          float photom = photomClose(one, two, sigma_photo);
          float weight = photom * geomClose(n, current, sigma_spatial);
          float value = image[hook(1, nx + (ny * iwidth))];
          if (!isnan(weight) && !isinf(weight) && !isnan(value) && !isinf(value)) {
            sumWeight += weight;
            sumFilter += weight * value;
          }
        }
      }
    }
  }
  float value = sumFilter / sumWeight;
  if (isnan(value))
    value = image[hook(1, x + (y * iwidth))];
  out[hook(2, x + (y * iwidth))] = value;
}