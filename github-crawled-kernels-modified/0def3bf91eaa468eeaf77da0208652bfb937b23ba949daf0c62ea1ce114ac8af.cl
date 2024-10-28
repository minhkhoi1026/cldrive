//{"Nhx":3,"h":1,"input":0,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve1d_buf(global float* input, constant float* h, global float* output, const int Nhx) {
  int i = get_global_id(0);
  int Nx = get_global_size(0);

  float res = 0.f;

  const int hx_start = ((i + Nhx / 2) >= Nx) ? i + Nhx / 2 + 1 - Nx : 0;
  const int hx_end = ((i - Nhx / 2) < 0) ? i + Nhx / 2 + 1 : Nhx;
  const int startx = i + Nhx / 2;

  for (int htx = hx_start; htx < hx_end; ++htx)
    res += h[hook(1, htx)] * input[hook(0, startx - htx)];

  output[hook(2, i)] = res;
}