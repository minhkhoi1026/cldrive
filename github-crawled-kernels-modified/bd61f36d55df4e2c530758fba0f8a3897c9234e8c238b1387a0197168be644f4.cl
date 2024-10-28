//{"batch":2,"exposure":7,"h":4,"image":0,"rand":1,"saturation":6,"scale":9,"shift":10,"train":5,"translate":8,"w":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float get_pixel_kernel(global float* image, int w, int h, int x, int y, int c) {
  if (x < 0 || x >= w || y < 0 || y >= h)
    return 0;
  return image[hook(0, x + w * (y + c * h))];
}

float3 rgb_to_hsv_kernel(float3 rgb) {
  float r = rgb.x;
  float g = rgb.y;
  float b = rgb.z;

  float h, s, v;
  float max_ = (r > g) ? ((r > b) ? r : b) : ((g > b) ? g : b);
  float min_ = (r < g) ? ((r < b) ? r : b) : ((g < b) ? g : b);
  float delta = max_ - min_;
  v = max_;
  if (max_ == 0) {
    s = 0;
    h = -1;
  } else {
    s = delta / max_;
    if (r == max_) {
      h = (g - b) / delta;
    } else if (g == max_) {
      h = 2 + (b - r) / delta;
    } else {
      h = 4 + (r - g) / delta;
    }
    if (h < 0)
      h += 6;
  }
  return (float3)(h, s, v);
}

float3 hsv_to_rgb_kernel(float3 hsv) {
  float h = hsv.x;
  float s = hsv.y;
  float v = hsv.z;

  float r, g, b;
  float f, p, q, t;

  if (s == 0) {
    r = g = b = v;
  } else {
    int index = (int)floor(h);
    f = h - index;
    p = v * (1 - s);
    q = v * (1 - s * f);
    t = v * (1 - s * (1 - f));
    if (index == 0) {
      r = v;
      g = t;
      b = p;
    } else if (index == 1) {
      r = q;
      g = v;
      b = p;
    } else if (index == 2) {
      r = p;
      g = v;
      b = t;
    } else if (index == 3) {
      r = p;
      g = q;
      b = v;
    } else if (index == 4) {
      r = t;
      g = p;
      b = v;
    } else {
      r = v;
      g = p;
      b = q;
    }
  }
  r = (r < 0) ? 0 : ((r > 1) ? 1 : r);
  g = (g < 0) ? 0 : ((g > 1) ? 1 : g);
  b = (b < 0) ? 0 : ((b > 1) ? 1 : b);
  return (float3)(r, g, b);
}

float bilinear_interpolate_kernel(global float* image, int w, int h, float x, float y, int c) {
  int ix = (int)floor(x);
  int iy = (int)floor(y);

  float dx = x - ix;
  float dy = y - iy;

  float val = (1 - dy) * (1 - dx) * get_pixel_kernel(image, w, h, ix, iy, c) + dy * (1 - dx) * get_pixel_kernel(image, w, h, ix, iy + 1, c) + (1 - dy) * dx * get_pixel_kernel(image, w, h, ix + 1, iy, c) + dy * dx * get_pixel_kernel(image, w, h, ix + 1, iy + 1, c);
  return val;
}

kernel void levels_image_kernel(global float* image, global float* rand, int batch, int w, int h, int train, float saturation, float exposure, float translate, float scale, float shift) {
  int size = batch * w * h;

  int id = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (id >= size)
    return;
  int x = id % w;
  id /= w;
  int y = id % h;
  id /= h;
  float rshift = rand[hook(1, 0)];
  float gshift = rand[hook(1, 1)];
  float bshift = rand[hook(1, 2)];
  float r0 = rand[hook(1, 8 * id + 0)];
  float r1 = rand[hook(1, 8 * id + 1)];
  float r2 = rand[hook(1, 8 * id + 2)];
  float r3 = rand[hook(1, 8 * id + 3)];

  saturation = r0 * (saturation - 1) + 1;
  saturation = (r1 > .5f) ? 1.f / saturation : saturation;
  exposure = r2 * (exposure - 1) + 1;
  exposure = (r3 > .5f) ? 1.f / exposure : exposure;

  size_t offset = id * h * w * 3;

  float r = image[hook(0, x + w * (y + h * 0) + offset)];
  float g = image[hook(0, x + w * (y + h * 1) + offset)];
  float b = image[hook(0, x + w * (y + h * 2) + offset)];
  float3 rgb = (float3)(r, g, b);
  if (train) {
    float3 hsv = rgb_to_hsv_kernel(rgb);
    hsv.y *= saturation;
    hsv.z *= exposure;
    rgb = hsv_to_rgb_kernel(hsv);
  } else {
    shift = 0;
  }
  image[hook(0, x + w * (y + h * 0) + offset)] = rgb.x * scale + translate + (rshift - .5f) * shift;
  image[hook(0, x + w * (y + h * 1) + offset)] = rgb.y * scale + translate + (gshift - .5f) * shift;
  image[hook(0, x + w * (y + h * 2) + offset)] = rgb.z * scale + translate + (bshift - .5f) * shift;
}