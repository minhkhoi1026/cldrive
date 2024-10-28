//{"out":0,"position":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float get_red_from_table(size_t id) {
  switch (id) {
    case 0:
      return 10.50000f;
    case 1:
      return 3.15846f;
    case 2:
      return 0.39901f;
    case 3:
      return 0.50955f;
    case 4:
      return 2.98021f;
    case 5:
      return 7.85507f;
    case 6:
      return 15.74049f;
    case 7:
      return 27.02524f;
    case 8:
      return 43.28563f;
    case 9:
      return 66.63533f;
    case 10:
      return 95.10477f;
    case 11:
      return 126.26711f;
    case 12:
      return 157.66678f;
    case 13:
      return 186.96906f;
    case 14:
      return 211.81561f;
    case 15:
      return 229.84409f;
    case 16:
      return 239.00920f;
    case 17:
      return 244.51880f;
    case 18:
      return 248.55106f;
    case 19:
      return 251.45792f;
    case 20:
      return 253.30617f;
    case 21:
      return 254.38364f;
    case 22:
      return 254.87805f;
    case 23:
      return 254.50528f;
    case 24:
      return 242.28555f;
    case 25:
      return 216.25360f;
    case 26:
      return 181.10410f;
    case 27:
      return 141.51198f;
    case 28:
      return 102.12467f;
    case 29:
      return 67.43021f;
    case 30:
      return 41.82657f;
    case 31:
      return 23.33998f;
    default:
      return -1.0f;
  }
}

float get_green_from_table(size_t id) {
  switch (id) {
    case 0:
      return 2.24772f;
    case 1:
      return 4.38378f;
    case 2:
      return 6.41868f;
    case 3:
      return 11.69186f;
    case 4:
      return 25.28062f;
    case 5:
      return 45.46635f;
    case 6:
      return 70.00731f;
    case 7:
      return 97.07170f;
    case 8:
      return 124.60256f;
    case 9:
      return 151.26897f;
    case 10:
      return 176.37556f;
    case 11:
      return 199.12393f;
    case 12:
      return 218.84903f;
    case 13:
      return 234.93768f;
    case 14:
      return 246.77850f;
    case 15:
      return 253.58151f;
    case 16:
      return 254.53967f;
    case 17:
      return 251.94934f;
    case 18:
      return 245.78825f;
    case 19:
      return 236.19637f;
    case 20:
      return 223.36536f;
    case 21:
      return 207.15530f;
    case 22:
      return 187.81662f;
    case 23:
      return 165.01135f;
    case 24:
      return 136.81346f;
    case 25:
      return 105.00961f;
    case 26:
      return 72.90131f;
    case 27:
      return 43.46163f;
    case 28:
      return 19.82122f;
    case 29:
      return 5.26334f;
    case 30:
      return 2.20703f;
    case 31:
      return 2.29760f;
    default:
      return -1.0f;
  }
}

float get_blue_from_table(size_t id) {
  switch (id) {
    case 0:
      return 68.50000f;
    case 1:
      return 79.36879f;
    case 2:
      return 95.08916f;
    case 3:
      return 116.73592f;
    case 4:
      return 138.96797f;
    case 5:
      return 160.55014f;
    case 6:
      return 180.41800f;
    case 7:
      return 197.60361f;
    case 8:
      return 211.45720f;
    case 9:
      return 223.10614f;
    case 10:
      return 232.60995f;
    case 11:
      return 240.26654f;
    case 12:
      return 246.22346f;
    case 13:
      return 250.50687f;
    case 14:
      return 253.26976f;
    case 15:
      return 254.57617f;
    case 16:
      return 253.42593f;
    case 17:
      return 231.85834f;
    case 18:
      return 191.35536f;
    case 19:
      return 140.38916f;
    case 20:
      return 87.35393f;
    case 21:
      return 40.69637f;
    case 22:
      return 9.10403f;
    case 23:
      return 0.47247f;
    case 24:
      return 1.70649f;
    case 25:
      return 5.54085f;
    case 26:
      return 11.43449f;
    case 27:
      return 19.26110f;
    case 28:
      return 28.73091f;
    case 29:
      return 39.77259f;
    case 30:
      return 51.72056f;
    case 31:
      return 60.93956f;
    default:
      return -1.0f;
  }
}

float get_red(double input) {
  float colid = (float)(input * 32.0f);

  size_t colid1 = (size_t)colid;
  size_t colid2 = (colid + 1);

  if (colid2 == 32)
    colid2 = 0;

  float col2pct = colid - colid1;
  float col1pct = 1.0f - col2pct;

  float col1 = get_red_from_table(colid1);
  float col2 = get_red_from_table(colid2);

  float col = col1 * col1pct + col2 * col2pct;

  return col;
}

float get_green(double input) {
  float colid = (float)(input * 32.0f);

  size_t colid1 = (size_t)colid;
  size_t colid2 = (colid + 1);

  if (colid2 == 32)
    colid2 = 0;

  float col2pct = colid - colid1;
  float col1pct = 1.0f - col2pct;

  float col1 = get_green_from_table(colid1);
  float col2 = get_green_from_table(colid2);

  float col = col1 * col1pct + col2 * col2pct;

  return col;
}

float get_blue(double input) {
  float colid = (float)(input * 32.0f);

  size_t colid1 = (size_t)colid;
  size_t colid2 = (colid + 1);

  if (colid2 == 32)
    colid2 = 0;

  float col2pct = colid - colid1;
  float col1pct = 1.0f - col2pct;

  float col1 = get_blue_from_table(colid1);
  float col2 = get_blue_from_table(colid2);

  float col = col1 * col1pct + col2 * col2pct;

  return col;
}

kernel void precompute_mandelbrot(global unsigned char* out, global double* position) {
  size_t tid_x = get_global_id(0);
  size_t tid_y = get_global_id(1);
  size_t size_x = get_global_size(0);
  size_t size_y = get_global_size(1);

  double startx = position[hook(1, 0)];
  double starty = position[hook(1, 1)];
  double hori_pixdist_x = position[hook(1, 2)];
  double hori_pixdist_y = position[hook(1, 3)];
  double vert_pixdist_x = position[hook(1, 4)];
  double vert_pixdist_y = position[hook(1, 5)];

  double posx = startx + (hori_pixdist_x * (((double)tid_x) - 1)) + (vert_pixdist_x * (((double)tid_y) - 1));
  double posy = starty + (hori_pixdist_y * (((double)tid_x) - 1)) + (vert_pixdist_y * (((double)tid_y) - 1));

  unsigned long maxiter = 50000;
  double bailout = 10000.0;

  double mag_square = 0.0;
  unsigned long iter = 0;

  double start_x = 0.0;
  double start_y = 0.0;
  double iter_x = posx;
  double iter_y = posy;

  double x = start_x;
  double y = start_y;

  while (mag_square <= bailout && iter < maxiter) {
    double xt = x * x - y * y + iter_x;
    double yt = 2 * x * y + iter_y;
    x = xt;
    y = yt;
    iter = iter + 1;
    mag_square = x * x + y * y;
  }

  if (iter == maxiter) {
    out[hook(0, size_x * tid_y + tid_x)] = (unsigned char)0;
  } else {
    out[hook(0, size_x * tid_y + tid_x)] = (unsigned char)1;
  }
}