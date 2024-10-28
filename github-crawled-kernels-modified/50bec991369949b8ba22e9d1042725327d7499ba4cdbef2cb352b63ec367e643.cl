//{"c_cos_angle":4,"c_sin_angle":3,"c_tX":5,"c_tY":6,"gicov":7,"grad_m":0,"grad_x":1,"grad_y":2,"height":9,"width":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GICOV_kernel(int grad_m, global float* grad_x, global float* grad_y, constant float* c_sin_angle, constant float* c_cos_angle, constant int* c_tX, constant int* c_tY, global float* gicov, int width, int height) {
  int i, j, k, n, x, y;
  int gid = get_global_id(0);
  if (gid >= width * height)
    return;

  i = gid / width + 20 + 2;
  j = gid % width + 20 + 2;

  float max_GICOV = 0.f;

  for (k = 0; k < 7; k++) {
    float sum = 0.f, M2 = 0.f, mean = 0.f;

    for (n = 0; n < 150; n++) {
      y = j + c_tY[hook(6, (k * 150) + n)];
      x = i + c_tX[hook(5, (k * 150) + n)];

      int addr = x * grad_m + y;
      float p = grad_x[hook(1, addr)] * c_cos_angle[hook(4, n)] + grad_y[hook(2, addr)] * c_sin_angle[hook(3, n)];

      sum += p;

      float delta = p - mean;
      mean = mean + (delta / (float)(n + 1));
      M2 = M2 + (delta * (p - mean));
    }

    mean = sum / ((float)150);

    float var = M2 / ((float)(150 - 1));

    if (((mean * mean) / var) > max_GICOV)
      max_GICOV = (mean * mean) / var;
  }

  gicov[hook(7, (i * grad_m) + j)] = max_GICOV;
}