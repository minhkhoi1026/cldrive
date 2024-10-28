//{"N":1,"by":0,"input":2,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float myAbs(float v) {
  if (v < 0)
    return -1.0 * v;
  else
    return v;
}

float lanczos(float x, int a) {
  if (x == 0)
    return 1;
  float absX = myAbs(x);
  if (0 < absX && absX < a)
    return (a * sin(3.1415926535897932384626433832795 * x) * sin(3.1415926535897932384626433832795 * x / a)) / (9.8696044010893586188344909998762 * x * x);
  return 0;
}

float gauss(float x, float d) {
  float tmp = x / d;
  tmp *= tmp;
  return (1.0 / (d * 2.506628274631000502415765284811)) * exp(-0.5 * tmp);
}

float gauss2(float x, float d) {
  float tmp = (x - 4.0 / 2) / (d * 4.0 / 2);
  tmp *= tmp;
  return (1.0 / (d * 2.506628274631000502415765284811)) * exp(-0.5 * tmp);
}

kernel void upSample2(int by, int N, global float* input, global float* output) {
  int idx = get_global_id(0);
  int center = idx / by;
  float x = (idx % by);
  x /= by;
  int b1 = center - 1;
  int b2 = center - 2;
  int a1 = center + 1;
  int a2 = center + 2;
  float y = gauss2(x, 0.4) * input[hook(2, center)];
  if (b1 >= 0)
    y += gauss2(x + 1, 0.4) * input[hook(2, b1)];
  if (b2 >= 0)
    y += gauss2(x + 2, 0.4) * input[hook(2, b2)];
  if (a1 < N)
    y += gauss2(x - 1, 0.4) * input[hook(2, a1)];
  if (a2 < N)
    y += gauss2(x - 2, 0.4) * input[hook(2, a2)];
  output[hook(3, idx)] = y;
}