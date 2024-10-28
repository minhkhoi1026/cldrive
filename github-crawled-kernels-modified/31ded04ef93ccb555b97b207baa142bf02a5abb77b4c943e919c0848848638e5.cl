//{"height":4,"hue":2,"input":0,"output":1,"sat":3,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void huergb_pkd(global unsigned char* input, global unsigned char* output, const double hue, const double sat, const unsigned int height, const unsigned int width) {
  int id = get_global_id(0);
  double r, g, b, min, max, delta;
  double temp1, temp2, temp3;

  id = id * 3;
  if (id < 3 * height * width) {
    r = input[hook(0, id)] / 255.0;
    g = input[hook(0, id + 1)] / 255.0;
    b = input[hook(0, id + 2)] / 255.0;

    min = (r < g && r < b) ? r : ((g < b) ? g : b);
    max = (r > g && r > b) ? r : ((g > b) ? g : b);

    delta = max - min;

    if (delta == 0)
      output[hook(1, id)] = 0;
    else {
      if (max == r)
        temp1 = 60 * ((g - b) / delta);
      else if (max == g)
        temp1 = 60 * ((b - r) / delta + 2);
      else
        temp1 = 60 * ((r - g) / delta + 4);
    }

    temp1 += hue;
    if (temp1 < 0)
      temp1 = temp1 + 360;
    else if (temp1 > 360)
      temp1 = temp1 - 360.0;

    if (max == 0)
      temp2 = 0;
    else
      temp2 = delta / max;
    temp2 += sat;
    temp3 = max;

    double hh, p, q, t, ff;
    int i;
    double h, s, v;

    int pixIdx = id;

    h = temp1;
    s = temp2;
    v = temp3;

    if (s <= 0) {
      output[hook(1, pixIdx)] = 0;
      output[hook(1, pixIdx + 1)] = 0;
      output[hook(1, pixIdx + 2)] = 0;
    }

    hh = h;
    if (h == 360.0) {
      hh = 0.0;
    }
    hh /= 60.0;
    i = (int)hh;
    ff = hh - i;
    p = v * (1.0 - s);
    q = v * (1.0 - (s * ff));
    t = v * (1.0 - (s * (1.0 - ff)));

    switch (i) {
      case 0:
        output[hook(1, pixIdx)] = v * 255;
        output[hook(1, pixIdx + 1)] = t * 255;
        output[hook(1, pixIdx + 2)] = p * 255;
        break;
      case 1:
        output[hook(1, pixIdx)] = q * 255;
        output[hook(1, pixIdx + 1)] = v * 255;
        output[hook(1, pixIdx + 2)] = p * 255;
        break;
      case 2:
        output[hook(1, pixIdx)] = p * 255;
        output[hook(1, pixIdx + 1)] = v * 255;
        output[hook(1, pixIdx + 2)] = t * 255;
        break;

      case 3:
        output[hook(1, pixIdx)] = p * 255;
        output[hook(1, pixIdx + 1)] = q * 255;
        output[hook(1, pixIdx + 2)] = v * 255;
        break;

      case 4:
        output[hook(1, pixIdx)] = t * 255;
        output[hook(1, pixIdx + 1)] = p * 255;
        output[hook(1, pixIdx + 2)] = v * 255;
        break;
      case 5:
      default:
        output[hook(1, pixIdx)] = v * 255;
        output[hook(1, pixIdx + 1)] = p * 255;
        output[hook(1, pixIdx + 2)] = q * 255;
        break;
    }
  }
}