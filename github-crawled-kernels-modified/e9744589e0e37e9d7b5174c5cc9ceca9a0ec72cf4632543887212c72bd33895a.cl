//{"Nhx":4,"Nhy":3,"h":1,"input":0,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve2d_buf_global(global float* input, global float* h, global float* output, const int Nhy, const int Nhx) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  int Nx = get_global_size(0);
  int Ny = get_global_size(1);

  float res = 0.f;

  const int hx_start = ((i + Nhx / 2) >= Nx) ? i + Nhx / 2 + 1 - Nx : 0;
  const int hx_end = ((i - Nhx / 2) < 0) ? i + Nhx / 2 + 1 : Nhx;
  const int startx = i + Nhx / 2;

  const int hy_start = ((j + Nhy / 2) >= Ny) ? j + Nhy / 2 + 1 - Ny : 0;
  const int hy_end = ((j - Nhy / 2) < 0) ? j + Nhy / 2 + 1 : Nhy;
  const int starty = j + Nhy / 2;

  for (int htx = hx_start; htx < hx_end; ++htx)
    for (int hty = hy_start; hty < hy_end; ++hty)
      res += h[hook(1, htx + hty * Nhx)] * input[hook(0, startx - htx + (starty - hty) * Nx)];

  output[hook(2, i + j * Nx)] = res;
}