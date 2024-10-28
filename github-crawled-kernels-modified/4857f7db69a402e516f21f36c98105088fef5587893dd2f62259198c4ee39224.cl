//{"height":2,"input":0,"output":1,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hsv2rgb_pkd(global const double* input, global unsigned char* output, const unsigned int height, const unsigned int width) {
  int pixIdx = get_global_id(0);
  double hh, p, q, t, ff;
  int i;
  double h, s, v;
  pixIdx = 3 * pixIdx;

  if (pixIdx < height * width * 3) {
    h = input[hook(0, pixIdx)];
    s = input[hook(0, pixIdx + 1)];
    v = input[hook(0, pixIdx + 2)];

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