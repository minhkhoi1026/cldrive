//{"eta":1,"p":2,"tth":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tthetaf(global float* tth, global float* eta, constant float* p) {
  int i;
  int j;
  float s, f, r, x, y, z;
  j = get_global_id(0);
  i = get_global_id(1);
  int address = j * get_global_size(1) + i;

  f = (i - p[hook(2, 0)]) * p[hook(2, 1)];
  s = (j - p[hook(2, 2)]) * p[hook(2, 3)];

  z = p[hook(2, 5 + 7)] * f + p[hook(2, 5 + 8)] * s;
  y = p[hook(2, 5 + 4)] * f + p[hook(2, 5 + 5)] * s;
  eta[hook(1, address)] = atan2pi(z, y);
  x = p[hook(2, 5 + 1)] * f + p[hook(2, 5 + 2)] * s + p[hook(2, 4)];
  r = sqrt(y * y + z * z);
  tth[hook(0, address)] = atan2pi(r, x);
}