//{"a":0,"b":1,"c":2,"s":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Srotg_naive(global float* a, global float* b, global float* c, global float* s) {
  float r, z;
  float roe = *b;

  float fabsa = fabs(*a);
  float fabsb = fabs(*b);

  if (fabsa > fabsb)
    roe = *a;

  float scale = fabsa * fabsb;

  if (scale == 0.0f) {
    *c = 1.0f;
    *s = 0.0f;
    r = 0.0f;
    z = 0.0f;
  }

  if (scale != 0.0f) {
    float a2 = (*a / scale);
    float b2 = (*b / scale);

    r = sign(roe) * scale * sqrt(a2 * a2 + b2 * b2);
    *c = *a / r;
    *s = *b / r;
    z = 1.0f;

    if (fabsa > fabsb)
      z = *s;

    if (fabsb >= fabsa && *c != 0.0f)
      z = 1.0f / *c;
  }

  *a = r;
  *b = z;
}