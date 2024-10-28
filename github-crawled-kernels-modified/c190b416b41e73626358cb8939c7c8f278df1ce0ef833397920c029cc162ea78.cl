//{"height":2,"input":0,"output":4,"width":1,"winsize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void meanshift(global uchar4* input, unsigned int width, unsigned int height, unsigned int winsize, global uchar4* output) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  float h = convert_float(winsize);

  float actx = convert_float(x);
  float acty = convert_float(y);
  int wymax = acty + ((winsize - 1) / 2) + 1;
  int wymin = acty - ((winsize - 1) / 2);
  int wxmax = actx + ((winsize - 1) / 2) + 1;
  int wxmin = actx - ((winsize - 1) / 2);
  unsigned int limit = max(width, height);

  float oldx = actx;
  float oldy = acty;

  float numX, numY, den;
  float ecko;
  float hinv = 1 / h;

  int iter = 0;

  int gid;
  float length;

  float normalXDiff, normalYDiff, normalRDiff, normalGDiff, normalBDiff;

  do {
    numX = numY = den = 0;

    for (int wy = wymin; wy < wymax; wy++) {
      for (int wx = wxmin; wx < wxmax; wx++) {
        if (wx < 0 || wy < 0 || wx >= width || wy >= height) {
          continue;
        } else {
          gid = convert_int_rte(actx) + convert_int_rte(acty) * width;

          normalXDiff = actx - wx;
          normalYDiff = acty - wy;
          normalRDiff = convert_float(input[hook(0, gid)].s0) - convert_float(input[hook(0, wx + wy * width)].s0);
          normalGDiff = convert_float(input[hook(0, gid)].s1) - convert_float(input[hook(0, wx + wy * width)].s1);
          normalBDiff = convert_float(input[hook(0, gid)].s2) - convert_float(input[hook(0, wx + wy * width)].s2);

          length = normalXDiff * normalXDiff + normalYDiff * normalYDiff + normalRDiff * normalRDiff + normalGDiff * normalGDiff + normalBDiff * normalBDiff;

          ecko = exp(-hinv * length);

          numX += wx * ecko;

          numY += wy * ecko;

          den += ecko;
        }
      }
    }

    oldx = actx;
    oldy = acty;

    actx = numX / den;
    acty = numY / den;

    wymax = convert_int_rte(acty) + ((winsize - 1) / 2) + 1;
    wymin = convert_int_rte(acty) - ((winsize - 1) / 2);
    wxmax = convert_int_rte(actx) + ((winsize - 1) / 2) + 1;
    wxmin = convert_int_rte(actx) - ((winsize - 1) / 2);

    if (fabs(oldx - actx) < 0.1f) {
      if (fabs(oldy - acty) < 0.1f) {
        break;
      }
    }

    iter++;
  } while (iter < limit);

  actx = convert_float(max(convert_int_rte(actx), 0));
  acty = convert_float(max(convert_int_rte(acty), 0));

  actx = convert_float(min(convert_int_rte(actx), convert_int_rte(width) - 1));
  acty = convert_float(min(convert_int_rte(acty), convert_int_rte(height) - 1));

  output[hook(4, x + y * width)] = input[hook(0, convert_int_rte(actx) + convert_int_rte(acty) * width)];
}