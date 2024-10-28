//{"arg0":3,"arg1":4,"height":2,"indexOfArr":5,"input":0,"num":6,"width":1,"xArr":7,"yArr":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float getLk(float x, int k, global float* xArr, int num) {
  float omigaXk = 1;
  float omigaX = 1;
  for (int i = 0; i < num; i++) {
    if (i != k) {
      omigaXk *= xArr[hook(7, k)] - xArr[hook(7, i)];
      omigaX *= x - xArr[hook(7, i)];
    }
  }
  float lk = omigaX / omigaXk;
  return lk;
}

float lagrange(global float* xArr, global float* yArr, float x, int num) {
  float L = 0;
  for (int k = 0; k < num; k++) {
    float lk = getLk(x, k, xArr, num);
    L += yArr[hook(8, k)] * lk;
  }
  return L;
}

kernel void curve(global float* input, const int width, const int height, global float* arg0, global float* arg1, global int* indexOfArr, const int num) {
  int ix = get_global_id(0);
  int iy = get_global_id(1);
  int realI = iy * width + ix;

  for (int j = 0; j < 3; j++) {
    if (indexOfArr[hook(5, j)] == 0)
      continue;
    input[hook(0, realI * 4 + j)] = lagrange(arg0, arg1, input[hook(0, realI * 4 + j)], num);
  }
}