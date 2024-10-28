//{"bgr32f":0,"height":2,"ptrHSV":4,"width":3,"widthStep":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((num_compute_units(4))) kernel void calc_hsv(global char* restrict bgr32f, const int widthStep, int height, int width) {
  int groups = get_num_groups(0);
  int tamGroup = get_local_size(0);
  int base = get_group_id(0);
  int lid = get_local_id(0);
  float h, b, g, r, min, max, delta;
  int despH, despS, despV;

  for (int f = base; f < height; f += groups) {
    global float* ptrHSV = (global float*)(bgr32f + widthStep * f);
    for (int col = lid; col < width; col += tamGroup) {
      despH = 3 * col;
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