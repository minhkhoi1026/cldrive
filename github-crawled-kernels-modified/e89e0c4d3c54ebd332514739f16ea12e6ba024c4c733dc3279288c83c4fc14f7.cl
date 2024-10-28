//{"height":2,"input":0,"output":1,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rgb2hsv_pkd(global unsigned char* input, global double* output, const unsigned int height, const unsigned int width) {
  int id = get_global_id(0);
  double r, g, b, min, max, delta;

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
        output[hook(1, id)] = 60 * ((g - b) / delta);
      else if (max == g)
        output[hook(1, id)] = 60 * ((b - r) / delta + 2);
      else
        output[hook(1, id)] = 60 * ((r - g) / delta + 4);
    }

    if (output[hook(1, id)] < 0)
      output[hook(1, id)] = output[hook(1, id)] + 360;
    if (max == 0)
      output[hook(1, id + 1)] = 0;
    else
      output[hook(1, id + 1)] = delta / max;
    output[hook(1, id + 2)] = max;
  }
}