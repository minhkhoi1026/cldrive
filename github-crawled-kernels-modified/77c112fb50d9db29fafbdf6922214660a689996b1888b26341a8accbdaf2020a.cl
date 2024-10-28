//{"S":6,"T":1,"X":0,"fracshift":4,"fsum_imag":8,"fsum_real":7,"g":5,"intshift":3,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float exppart(int, constant const float*, constant const float*, constant const float*, const int, constant const float*);
float normpart(int, constant const float*, constant const float*, const int, constant const float*);
float exppart(int i, constant const float* X, constant const float* intshift, constant const float* x, const int g, constant const float* S) {
  float sum = 0;
  float v_j, Xw_j;
  for (int j = 0; j < g; j++) {
    v_j = S[hook(6, i * g + j)] - intshift[hook(3, j)];

    Xw_j = 0;
    for (int k = 0; k < g; k++) {
      Xw_j += 0.5 * X[hook(0, j * g + k)] * (S[hook(6, i * g + k)] - intshift[hook(3, k)]);
    }
    Xw_j += x[hook(2, j)];

    sum += v_j * Xw_j;
  }

  return 2 * 3.141592653589793 * sum;
}

float normpart(int i, constant const float* T, constant const float* fracshift, const int g, constant const float* S) {
  float sum = 0;
  float v_j;

  for (int j = 0; j < g; j++) {
    v_j = 0;
    for (int k = 0; k < g; k++) {
      v_j += T[hook(1, j * g + k)] * (S[hook(6, i * g + k)] + fracshift[hook(4, k)]);
    }

    sum += v_j * v_j;
  }

  return -3.141592653589793 * sum;
}

kernel void finite_sum_without_derivs(constant const float* X, constant const float* T, constant const float* x, constant const float* intshift, constant const float* fracshift, const int g, constant const float* S, global float* fsum_real, global float* fsum_imag) {
  float ept, npt, cpart, spart;
  int i;
  i = get_global_id(0);

  ept = exppart(i, X, intshift, x, g, S);
  npt = exp(normpart(i, T, fracshift, g, S));

  cpart = npt * cos(ept);
  spart = npt * sin(ept);

  fsum_real[hook(7, i)] = cpart;
  fsum_imag[hook(8, i)] = spart;
}