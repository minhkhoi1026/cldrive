//{"dst":0,"height":3,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
inline int xy2idx(int x, int y, int w) {
  return y * w + x;
}

inline int2 idx2xy(int idx, int w) {
  int2 pos = (int2)(0);
  pos.x = idx % w;
  pos.y = (idx - (pos.x)) / w;
  return pos;
}

float ndp2(global const uchar* src, const int2 posFeature, const int2 posCandidate, const int2 featureSize, const int2 size) {
  float r = 0, lenL = 0, lenR = 0;
  int step = 2;

  float valL, valR;
  for (int dy = -featureSize.y; dy < featureSize.y; dy += 2)
    for (int dx = -featureSize.x; dx < featureSize.x; dx += 2) {
      valL = src[hook(1, xy2idx(clamp(posFeature.x + dx, 0, size.x), clamp(posFeature.y + dy, 0, size.y / 2), size.x))];
      valR = src[hook(1, xy2idx(clamp(posCandidate.x + dx, 0, size.x), clamp(posCandidate.y + dy, size.y / 2, size.y), size.x))];
      r += valL * valR;
      lenL += valL * valL;
      lenR += valR * valR;
    }

  r /= sqrt(lenL) * sqrt(lenR);

  return r;
}

float ndp2_dist(global const uchar* src, const int2 pos, const int2 ranges, const int2 ndp2Dim, const int2 size) {
  float match = 0, best_match = 0, dist_of_best = -1;
  int2 pos_of_best = (int2)(0);
  int step = 30;

  for (int dy = -ranges.y / 2; dy < ranges.y / 2; dy += step)
    for (int dx = -ranges.x / 2; dx < ranges.x / 2; dx += step) {
      int2 posCandidate = (int2)(0);
      posCandidate.x = clamp(pos.x + dx, 0, size.x);
      posCandidate.y = clamp(pos.y + dy + size.y / 2, size.y / 2, size.y);

      match = ndp2(src, pos, posCandidate, ndp2Dim, size);

      if (match > best_match) {
        best_match = match;
        dist_of_best = sqrt(convert_float(dx * dx + dy * dy));
        pos_of_best = posCandidate;
      }
    }

  dist_of_best /= sqrt(pow((float)(ranges.x), 2.0f) * pow((float)(ranges.y), 2.0f));
  dist_of_best = pow(dist_of_best, 1.0f / 20.0f);

  return dist_of_best;
}

kernel void bidiff(global uchar* dst, global const uchar* src, const int width, const int height) {
  int x = get_global_id(0), y = get_global_id(1);
  int w = height / 2;
  int idx = xy2idx(x, y, width);
  int2 pos = (int2)(x, y);
  int2 size = (int2)(width, height);

  int d = 30, rh = 400, rv = 1.1 * d;
  int2 ndp2Dim = (int2)(d, d);

  int2 ranges = (int2)(rh, rv);

  if (y < w) {
    float r = 0;

    r = ndp2_dist(src, pos, ranges, ndp2Dim, size);
    r *= 200;
    r += 50;

    dst[hook(0, idx)] = r;
  } else {
    dst[hook(0, idx)] = src[hook(1, idx)];
  }
}