//{"flags":2,"ih":5,"iw":4,"label":0,"pass":3,"pix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void label8xMain_int_int(global int* label, global int* pix, global int* flags, int pass, int iw, int ih) {
  const int x = get_global_id(0), y = get_global_id(1);
  if (x >= iw || y >= ih)
    return;
  const int p0 = y * iw + x;

  if (flags[hook(2, pass - 1)] == 0)
    return;

  int g = label[hook(0, p0)], og = g;

  if (g == -1)
    return;

  for (int yy = -1; yy <= 1; yy++) {
    for (int xx = -1; xx <= 1; xx++) {
      if (0 <= x + xx && x + xx < iw && 0 <= y + yy && y + yy < ih) {
        const int p1 = (y + yy) * iw + x + xx, s = label[hook(0, p1)];
        if (s != -1 && s < g)
          g = s;
      }
    }
  }

  for (int j = 0; j < 6; j++)
    g = label[hook(0, g)];

  if (g != og) {
    atomic_min(&label[hook(0, og)], g);
    atomic_min(&label[hook(0, p0)], g);
    flags[hook(2, pass)] = 1;
  }
}