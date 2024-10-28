//{"k":2,"level":1,"xs":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitonic(global float* xs, int level, int k) {
  int i = get_global_id(0);

  int a = i;
  int b = i + (1 << k);

  int a1 = a % (1 << (level + 2));
  int b1 = b % (1 << (level + 2));
  int cut1 = (1 << (level + 1));

  int a2 = a % (1 << (k + 2));
  int b2 = b % (1 << (k + 2));
  int cut2 = (1 << (k + 1));

  if (a1 < cut1 && b1 < cut1) {
    if ((a2 < cut2 && b2 < cut2) || (a2 >= cut2 && b2 >= cut2)) {
      float _a = xs[hook(0, a)], _b = xs[hook(0, b)];
      if (_a > _b)
        xs[hook(0, a)] = _b, xs[hook(0, b)] = _a;
    }
  } else if (a1 >= cut1 && b1 >= cut1) {
    if ((a2 < cut2 && b2 < cut2) || (a2 >= cut2 && b2 >= cut2)) {
      float _a = xs[hook(0, a)], _b = xs[hook(0, b)];
      if (_a < _b)
        xs[hook(0, a)] = _b, xs[hook(0, b)] = _a;
    }
  }
}