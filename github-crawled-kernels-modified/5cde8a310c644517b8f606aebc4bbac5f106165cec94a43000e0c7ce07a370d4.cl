//{"Corrected_Volumes":0,"DATA_D":5,"DATA_H":4,"DATA_T":6,"DATA_W":3,"Volumes":1,"delta":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Calculate2DIndex(int x, int y, int DATA_W) {
  return x + y * DATA_W;
}

int Calculate3DIndex(int x, int y, int z, int DATA_W, int DATA_H) {
  return x + y * DATA_W + z * DATA_W * DATA_H;
}

int Calculate4DIndex(int x, int y, int z, int t, int DATA_W, int DATA_H, int DATA_D) {
  return x + y * DATA_W + z * DATA_W * DATA_H + t * DATA_W * DATA_H * DATA_D;
}

float mymax(float a, float b) {
  if (a > b)
    return a;
  else
    return b;
}

float InterpolateCubic(float p0, float p1, float p2, float p3, float delta) {
  float a0, a1, a2, a3, delta2;

  delta2 = delta * delta;
  a0 = p3 - p2 - p0 + p1;
  a1 = p0 - p1 - a0;
  a2 = p2 - p0;
  a3 = p1;

  return (a0 * delta * delta2 + a1 * delta2 + a2 * delta + a3);
}

kernel void SliceTimingCorrection(global float* Corrected_Volumes, global const float* Volumes, private float delta, private int DATA_W, private int DATA_H, private int DATA_D, private int DATA_T) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  if (x >= DATA_W || y >= DATA_H)
    return;

  float t0, t1, t2, t3;

  if (delta > 0.0f) {
    t0 = Volumes[hook(1, Calculate3DIndex(x, y, 0, DATA_W, DATA_H))];
    t1 = t0;
    t2 = Volumes[hook(1, Calculate3DIndex(x, y, 1, DATA_W, DATA_H))];
    t3 = Volumes[hook(1, Calculate3DIndex(x, y, 2, DATA_W, DATA_H))];

    for (int t = 0; t < DATA_T - 3; t++) {
      Corrected_Volumes[hook(0, Calculate3DIndex(x, y, t, DATA_W, DATA_H))] = InterpolateCubic(t0, t1, t2, t3, delta);

      t0 = t1;
      t1 = t2;
      t2 = t3;

      t3 = Volumes[hook(1, Calculate3DIndex(x, y, t + 3, DATA_W, DATA_H))];
    }

    int t = DATA_T - 3;
    Corrected_Volumes[hook(0, Calculate3DIndex(x, y, t, DATA_W, DATA_H))] = InterpolateCubic(t0, t1, t2, t3, delta);

    t = DATA_T - 2;
    t0 = t1;
    t1 = t2;
    t2 = t3;
    Corrected_Volumes[hook(0, Calculate3DIndex(x, y, t, DATA_W, DATA_H))] = InterpolateCubic(t0, t1, t2, t3, delta);

    t = DATA_T - 1;
    t0 = t1;
    t1 = t2;
    Corrected_Volumes[hook(0, Calculate3DIndex(x, y, t, DATA_W, DATA_H))] = InterpolateCubic(t0, t1, t2, t3, delta);
  }

  else {
    delta = 1.0f - (-delta);

    t0 = Volumes[hook(1, Calculate3DIndex(x, y, 0, DATA_W, DATA_H))];
    t1 = t0;
    t2 = t0;
    t3 = Volumes[hook(1, Calculate3DIndex(x, y, 1, DATA_W, DATA_H))];

    for (int t = 0; t < DATA_T - 2; t++) {
      Corrected_Volumes[hook(0, Calculate3DIndex(x, y, t, DATA_W, DATA_H))] = InterpolateCubic(t0, t1, t2, t3, delta);

      t0 = t1;
      t1 = t2;
      t2 = t3;

      t3 = Volumes[hook(1, Calculate3DIndex(x, y, t + 2, DATA_W, DATA_H))];
    }

    int t = DATA_T - 2;
    Corrected_Volumes[hook(0, Calculate3DIndex(x, y, t, DATA_W, DATA_H))] = InterpolateCubic(t0, t1, t2, t3, delta);

    t = DATA_T - 1;
    t0 = t1;
    t1 = t2;
    t2 = t3;
    Corrected_Volumes[hook(0, Calculate3DIndex(x, y, t, DATA_W, DATA_H))] = InterpolateCubic(t0, t1, t2, t3, delta);
  }
}