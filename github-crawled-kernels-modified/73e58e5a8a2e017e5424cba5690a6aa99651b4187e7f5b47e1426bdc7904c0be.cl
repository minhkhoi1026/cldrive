//{"angle":10,"c":3,"crop_height":6,"crop_width":7,"flip":9,"h":4,"image":12,"input":0,"output":11,"rand":1,"size":2,"train":8,"w":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float get_pixel_kernel(global float* image, int w, int h, int x, int y, int c) {
  if (x < 0 || x >= w || y < 0 || y >= h)
    return 0;
  return image[hook(12, x + w * (y + c * h))];
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

kernel void forward_crop_layer_kernel(global float* input, global float* rand, int size, int c, int h, int w, int crop_height, int crop_width, int train, int flip, float angle, global float* output) {
  int id = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (id >= size)
    return;

  float cx = w / 2.f;
  float cy = h / 2.f;

  int count = id;
  int j = id % crop_width;
  id /= crop_width;
  int i = id % crop_height;
  id /= crop_height;
  int k = id % c;
  id /= c;
  int b = id;

  float r4 = rand[hook(1, 8 * b + 4)];
  float r5 = rand[hook(1, 8 * b + 5)];
  float r6 = rand[hook(1, 8 * b + 6)];
  float r7 = rand[hook(1, 8 * b + 7)];

  float dw = (w - crop_width) * r4;
  float dh = (h - crop_height) * r5;
  flip = (flip && (r6 > .5f));
  angle = 2 * angle * r7 - angle;
  if (!train) {
    dw = (w - crop_width) / 2.f;
    dh = (h - crop_height) / 2.f;
    flip = 0;
    angle = 0;
  }

  input += w * h * c * b;

  float x = (flip) ? w - dw - j - 1 : j + dw;
  float y = i + dh;

  float rx = cos(angle) * (x - cx) - sin(angle) * (y - cy) + cx;
  float ry = sin(angle) * (x - cx) + cos(angle) * (y - cy) + cy;

  output[hook(11, count)] = bilinear_interpolate_kernel(input, w, h, rx, ry, k);
}