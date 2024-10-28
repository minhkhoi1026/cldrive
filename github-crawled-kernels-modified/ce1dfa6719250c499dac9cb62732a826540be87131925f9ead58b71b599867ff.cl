//{"data":9,"g_data":0,"g_odata":1,"highlight":7,"imgh":3,"imgw":2,"radius":5,"sdata":8,"threshold":6,"tilew":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int iclamp(int x, int a, int b) {
  return max(a, min(b, x));
}

unsigned int rgbToInt(float r, float g, float b) {
  r = clamp(r, 0.0f, 255.0f);
  g = clamp(g, 0.0f, 255.0f);
  b = clamp(b, 0.0f, 255.0f);
  return (convert_uint(b) << 16) + (convert_uint(g) << 8) + convert_uint(r);
}

unsigned int getPixel(global unsigned int* data, int x, int y, int width, int height) {
  x = iclamp(x, 0, width - 1);
  y = iclamp(y, 0, height - 1);
  return data[hook(9, y * width + x)];
}
kernel void postprocess(global unsigned int* g_data, global unsigned int* g_odata, int imgw, int imgh, int tilew, int radius, float threshold, float highlight, local unsigned int* sdata) {
  const int tx = get_local_id(0);
  const int ty = get_local_id(1);
  const int bw = get_local_size(0);
  const int bh = get_local_size(1);
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= imgw || y >= imgh)
    return;

  sdata[hook(8, (radius + ty) * tilew + (radius + tx))] = getPixel(g_data, x, y, imgw, imgh);

  if (tx < radius) {
    sdata[hook(8, (radius + ty) * tilew + (tx))] = getPixel(g_data, x - radius, y, imgw, imgh);

    sdata[hook(8, (radius + ty) * tilew + (radius + bw + tx))] = getPixel(g_data, x + bw, y, imgw, imgh);
  }
  if (ty < radius) {
    sdata[hook(8, (ty) * tilew + (radius + tx))] = getPixel(g_data, x, y - radius, imgw, imgh);

    sdata[hook(8, (radius + bh + ty) * tilew + (radius + tx))] = getPixel(g_data, x, y + bh, imgw, imgh);
  }

  if ((tx < radius) && (ty < radius)) {
    sdata[hook(8, (ty) * tilew + (tx))] = getPixel(g_data, x - radius, y - radius, imgw, imgh);

    sdata[hook(8, (radius + bh + ty) * tilew + (tx))] = getPixel(g_data, x - radius, y + bh, imgw, imgh);

    sdata[hook(8, (ty) * tilew + (radius + bw + tx))] = getPixel(g_data, x + bh, y - radius, imgw, imgh);

    sdata[hook(8, (radius + bh + ty) * tilew + (radius + bw + tx))] = getPixel(g_data, x + bw, y + bh, imgw, imgh);
  }

  barrier(0x01);

  float rsum = 0.0f;
  float gsum = 0.0f;
  float bsum = 0.0f;
  float samples = 0.0f;

  for (int dy = -radius; dy <= radius; dy++) {
    for (int dx = -radius; dx <= radius; dx++) {
      unsigned int pixel = sdata[hook(8, (radius + ty + dy) * tilew + (radius + tx + dx))];

      float l = dx * dx + dy * dy;
      if (l <= radius * radius) {
        float r = convert_float(pixel & 0x0ff);
        float g = convert_float((pixel >> 8) & 0x0ff);
        float b = convert_float((pixel >> 16) & 0x0ff);

        float lum = (r + g + b) * 0.001307189542f;
        if (lum > threshold) {
          r *= highlight;
          g *= highlight;
          b *= highlight;
        }

        rsum += r;
        gsum += g;
        bsum += b;
        samples += 1.0f;
      }
    }
  }

  rsum /= samples;
  gsum /= samples;
  bsum /= samples;

  g_odata[hook(1, y * imgw + x)] = rgbToInt(rsum, gsum, bsum);
}