//{"bgr32f":0,"height":2,"ptrHSV":4,"width":3,"widthStep":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_hsv(global char* bgr32f, int widthStep, int height, int width) {
  int base = get_global_id(0);
  int tam = get_global_size(0);
  float h, b, g, r, min, max, delta;
  int despH, despS, despV;

  for (int f = base; f < height; f += tam) {
    global float* ptrHSV = (global float*)(bgr32f + widthStep * f);
    for (int col = despH = 0; col < width; ++col, despH += 3) {
      despS = despH + 1;
      despV = despH + 2;
      b = ptrHSV[hook(4, despH)];
      g = ptrHSV[hook(4, despS)];
      r = ptrHSV[hook(4, despV)];
      min = ((((b) > (g) ? (g) : (b))) > (r) ? (r) : (((b) > (g) ? (g) : (b))));
      ptrHSV[hook(4, despV)] = max = ((((b) < (g) ? (g) : (b))) < (r) ? (r) : (((b) < (g) ? (g) : (b))));
      if (max != min) {
        delta = max - min;
        ptrHSV[hook(4, despS)] = delta / max;
        if (r == max)
          h = (g - b) / delta;
        else if (g == max)
          h = 2.0f + ((b - r) / delta);
        else
          h = 4.0f + ((r - g) / delta);
        h *= 60.0f;
        if (h < 0.0f)
          h += 360.0f;
        ptrHSV[hook(4, despH)] = h;
      } else {
        ptrHSV[hook(4, despH)] = 0.0f;
        ptrHSV[hook(4, despS)] = 0.0f;
      }
    }
  }
}