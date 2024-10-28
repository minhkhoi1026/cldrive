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

kernel void upSample(int by, int N, global float* input, global float* output) {
  int idx = get_global_id(0);
  int center = idx / by;
  float x = (idx % by);
  x /= by;
  int b1 = center - 1;
  int b2 = center - 2;
  int a1 = center + 1;
  int a2 = center + 2;
  float y = lanczos(x, 2) * input[hook(2, center)];
  if (b1 >= 0)
    y += lanczos(x + 1, 2) * input[hook(2, b1)];
  if (b2 >= 0)
    y += lanczos(x + 2, 2) * input[hook(2, b2)];
  if (a1 < N)
    y += lanczos(x - 1, 2) * input[hook(2, a1)];
  if (a2 < N)
    y += lanczos(x - 2, 2) * input[hook(2, a2)];
  output[hook(3, idx)] = y;
}