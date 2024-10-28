//{"coef0":9,"data":0,"dataLen":1,"degree":10,"gamma":8,"i":4,"kernel_type":5,"len":3,"px":12,"py":13,"start":2,"x":6,"xW":7,"x_square":11,"y":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
enum { C_SVC = 0, NU_SVC, ONE_CLASS, EPSILON_SVR, NU_SVR };
enum { LINEAR = 0, POLY, RBF, SIGMOID, PRECOMPUTED };
enum { LOWER_BOUND = 0, UPPER_BOUND, FREE };

double my_dot(global const double* px, global const double* py, const int xW) {
  double sum = 0;
  int i = 0;
  while (i < xW - 1) {
    int remain = xW - i;
    if (remain >= 8) {
      double8 xv = vload8(i / 8, px);
      double8 yv = vload8(i / 8, py);
      double8 d = xv * yv;
      sum += d.s0 + d.s1 + d.s2 + d.s3 + d.s4 + d.s5 + d.s6 + d.s7;
      i += 8;
    } else if (remain >= 4) {
      double4 xv = vload4(i / 4, px);
      double4 yv = vload4(i / 4, py);
      double4 d = xv * yv;
      sum += d.x + d.y + d.z + d.w;
      i += 4;
    } else if (remain >= 2) {
      double2 xv = vload2(i / 2, px);
      double2 yv = vload2(i / 2, py);
      double2 d = xv * yv;
      sum += d.x + d.y;
      i += 2;
    } else if (remain >= 1) {
      double d = px[hook(12, i)] * py[hook(13, i)];
      sum += d;
      i++;
    }
  }
  return sum;
}

double kernel_linear(const int i, const int j, global const double* x, const int xW) {
  return my_dot(&x[hook(6, i * xW)], &x[hook(6, j * xW)], xW);
}

double kernel_poly(const int i, const int j, global const double* x, const int xW, const double gamma, const double coef0, const int degree) {
  return pow(gamma * my_dot(&x[hook(6, i * xW)], &x[hook(6, j * xW)], xW) + coef0, degree);
}

double kernel_rbf(const int i, const int j, global const double* x, const int xW, double gamma, global double* x_square) {
  return exp(-gamma * (x_square[hook(11, i)] + x_square[hook(11, j)] - 2 * my_dot(&x[hook(6, i * xW)], &x[hook(6, j * xW)], xW)));
}

double kernel_sigmoid(const int i, const int j, global const double* x, const int xW, const double gamma, const double coef0) {
  return tanh(gamma * my_dot(&x[hook(6, i * xW)], &x[hook(6, j * xW)], xW) + coef0);
}

double kernel_precomputed(const int i, const int j, global const double* x, const int xW) {
  int jIndex = (int)x[hook(6, j * xW)];
  return x[hook(6, i * xW + jIndex)];
}

float svrQgetQ_f(const int len, const int i, const int kernel_type, global const double* x, const int xW, const double gamma, const double coef0, const int degree, global double* x_square, const int index) {
  float retVal = 0.f;
  switch (abs(kernel_type)) {
    case LINEAR:
      retVal = (float)kernel_linear(i, index, x, xW);
      break;
    case POLY:
      retVal = (float)kernel_poly(i, index, x, xW, gamma, coef0, degree);
      break;
    case RBF:
      retVal = (float)kernel_rbf(i, index, x, xW, gamma, x_square);
      break;
    case SIGMOID:
      retVal = (float)kernel_sigmoid(i, index, x, xW, gamma, coef0);
      break;
    case PRECOMPUTED:
      retVal = (float)kernel_precomputed(i, index, x, xW);
      break;
  }
  return retVal;
}

float svcQgetQ_f(const int len, const int i, const int kernel_type, global const char* y, global const double* x, const int xW, double gamma, double coef0, int degree, global double* x_square, const int index) {
  float res = y[hook(14, i)] * y[hook(14, index)];
  switch (abs(kernel_type)) {
    case LINEAR:
      res *= (float)kernel_linear(i, index, x, xW);
      break;
    case POLY:
      res *= (float)kernel_poly(i, index, x, xW, gamma, coef0, degree);
      break;
    case RBF:
      res *= (float)kernel_rbf(i, index, x, xW, gamma, x_square);
      break;
    case SIGMOID:
      res *= (float)kernel_sigmoid(i, index, x, xW, gamma, coef0);
      break;
    case PRECOMPUTED:
      res *= (float)kernel_precomputed(i, index, x, xW);
      break;
  }
  return res;
}

kernel void svrQgetQ(global float* data, const int dataLen, const int start, const int len, const int i, const int kernel_type, global const double* x, const int xW, const double gamma, const double coef0, const int degree, global double* x_square) {
  const int index = get_global_id(0);
  const int realIndex = index + start;
  if (realIndex < dataLen) {
    data[hook(0, realIndex)] = svrQgetQ_f(len, i, kernel_type, x, xW, gamma, coef0, degree, x_square, realIndex);
  }
}