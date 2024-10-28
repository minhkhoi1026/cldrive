//{"res_g":1,"t_g":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float alpha(int j) {
  if (1 <= j && j <= (64 - 1))
    return 1;
  else
    return 0;
}

float beta(int j) {
  return 0;
}

kernel void proc(global const float* t_g, global float* res_g) {
  int gid = get_global_id(0);

  int N = 64;
  int c = 1;
  int m = 1;
  int t = t_g[hook(0, gid)];
  int j = 0;
  float wk;
  float wn = 2 * sqrt((float)c / (float)m);
  float tmp;

  tmp = 0;
  {
    for (int i = 1; i <= N; i++)
      tmp += alpha(i);
  }
  res_g[hook(1, gid)] = tmp / N;

  tmp = 0;
  {
    for (int i = 1; i <= N; i++)
      tmp += beta(i);
  }
  res_g[hook(1, gid)] += tmp * t / N;

  tmp = 0;
  {
    for (int k = 1; k <= N / 2 - 1; k++) {
      wk = 2 * sqrt((float)c / (float)m) * sin(3.14159265358979323846264338327950288f * k / N);
      float tmp1, tmp2;

      tmp1 = 0;
      {
        tmp2 = 0;
        for (int i = 1; i <= N; i++)
          tmp2 += beta(i) * cos(2 * 3.14159265358979323846264338327950288f * k * i / N);
        tmp1 += 2 * tmp2 * sin(wk * t) / (wk * N);

        tmp2 = 0;
        for (int i = 1; i <= N; i++)
          tmp2 += alpha(i) * cos(2 * 3.14159265358979323846264338327950288f * k * i / N);
        tmp1 += 2 * tmp2 * cos(wk * t) / N;

        tmp1 *= cos(2 * 3.14159265358979323846264338327950288f * k * j / N);
      }
      tmp += tmp1;

      tmp1 = 0;
      {
        tmp2 = 0;
        for (int i = 1; i <= N; i++)
          tmp2 += beta(i) * sin(2 * 3.14159265358979323846264338327950288f * k * i / N);
        tmp1 += 2 * tmp2 * sin(wk * t) / (wk * N);

        tmp2 = 0;
        for (int i = 1; i <= N; i++)
          tmp2 += alpha(i) * sin(2 * 3.14159265358979323846264338327950288f * k * i / N);
        tmp1 += 2 * tmp2 * cos(wk * t) / N;

        tmp1 *= sin(2 * 3.14159265358979323846264338327950288f * k * j / N);
      }
      tmp += tmp1;
    }
  }
  res_g[hook(1, gid)] += tmp;

  tmp = 0;
  {
    float tmp1;

    tmp1 = 0;
    for (int i = 1; i <= N; i++)
      tmp1 += pow(-1, (float)i) * beta(i);
    tmp += tmp1 * sin(wn * t) / (wn * N);

    tmp1 = 0;
    for (int i = 1; i <= N; i++)
      tmp1 += pow(-1, (float)i) * alpha(i);
    tmp += tmp1 * cos(wn * t) / N;
  }
  res_g[hook(1, gid)] += tmp * pow(-1, (float)j);
}