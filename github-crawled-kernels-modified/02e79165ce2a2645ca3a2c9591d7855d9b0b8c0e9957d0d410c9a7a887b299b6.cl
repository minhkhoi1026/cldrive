//{"Nhx":5,"Nhy":4,"Nhz":3,"h":1,"input":0,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve3d_buf(global float* input, constant float* h, global float* output, const int Nhz, const int Nhy, const int Nhx) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int k = get_global_id(2);

  int Nx = get_global_size(0);
  int Ny = get_global_size(1);
  int Nz = get_global_size(2);

  float res = 0.f;
  const int hx_start = ((i + Nhx / 2) >= Nx) ? i + Nhx / 2 + 1 - Nx : 0;
  const int hx_end = ((i - Nhx / 2) < 0) ? i + Nhx / 2 + 1 : Nhx;
  const int startx = i + Nhx / 2;

  const int hy_start = ((j + Nhy / 2) >= Ny) ? j + Nhy / 2 + 1 - Ny : 0;
  const int hy_end = ((j - Nhy / 2) < 0) ? j + Nhy / 2 + 1 : Nhy;
  const int starty = j + Nhy / 2;

  const int hz_start = ((k + Nhz / 2) >= Nz) ? k + Nhz / 2 + 1 - Nz : 0;
  const int hz_end = ((k - Nhz / 2) < 0) ? k + Nhz / 2 + 1 : Nhz;
  const int startz = k + Nhz / 2;

  for (int htx = hx_start; htx < hx_end; ++htx)
    for (int hty = hy_start; hty < hy_end; ++hty)
      for (int htz = hz_start; htz < hz_end; ++htz)
        res += h[hook(1, htx + hty * Nhx + htz * Nhx * Nhy)] * input[hook(0, startx - htx + (starty - hty) * Nx + (startz - htz) * Nx * Ny)];

  output[hook(2, i + j * Nx + k * Nx * Ny)] = res;
}