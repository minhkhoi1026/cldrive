//{"coeffs":2,"dimx":3,"dimy":4,"dimz":5,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void stencil_3d(global float* input, global float* output, constant float* coeffs, int dimx, int dimy, int dimz) {
  int xgid = get_global_id(0);
  int ygid = get_global_id(1);
  int zgid;

  float laplacian;
  float current;
  float b00;
  float b01;
  float b02;
  float b03;
  float f00;
  float f01;
  float f02;
  float f03;
  float coef = 3 * coeffs[hook(2, 0)];

  if ((xgid < dimx) && (ygid < dimy)) {
    b03 = 0.;
    b02 = input[hook(0, (8 + dimx) * ((8 + dimy) * (-4 + 4) + ygid + 4) + xgid + 4)];
    b01 = input[hook(0, (8 + dimx) * ((8 + dimy) * (-3 + 4) + ygid + 4) + xgid + 4)];
    b00 = input[hook(0, (8 + dimx) * ((8 + dimy) * (-2 + 4) + ygid + 4) + xgid + 4)];
    current = input[hook(0, (8 + dimx) * ((8 + dimy) * (-1 + 4) + ygid + 4) + xgid + 4)];
    f00 = input[hook(0, (8 + dimx) * ((8 + dimy) * (0 + 4) + ygid + 4) + xgid + 4)];
    f01 = input[hook(0, (8 + dimx) * ((8 + dimy) * (1 + 4) + ygid + 4) + xgid + 4)];
    f02 = input[hook(0, (8 + dimx) * ((8 + dimy) * (2 + 4) + ygid + 4) + xgid + 4)];
    f03 = input[hook(0, (8 + dimx) * ((8 + dimy) * (3 + 4) + ygid + 4) + xgid + 4)];

    for (zgid = 0; zgid < dimz; zgid++) {
      b03 = b02;
      b02 = b01;
      b01 = b00;
      b00 = current;
      current = f00;
      f00 = f01;
      f01 = f02;
      f02 = f03;
      f03 = input[hook(0, (8 + dimx) * ((8 + dimy) * ((zgid + 4) + 4) + ygid + 4) + xgid + 4)];

      laplacian = coef * current + coeffs[hook(2, 1)] * (input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid + 1 + 4)] + input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid - 1 + 4)]) + coeffs[hook(2, 2)] * (input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid + 2 + 4)] + input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid - 2 + 4)]) + coeffs[hook(2, 3)] * (input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid + 3 + 4)] + input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid - 3 + 4)]) + coeffs[hook(2, 4)] * (input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid + 4 + 4)] + input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid - 4 + 4)])

                  + coeffs[hook(2, 1)] * (input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 1 + 4) + xgid + 4)] + input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid - 1 + 4) + xgid + 4)]) + coeffs[hook(2, 2)] * (input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 2 + 4) + xgid + 4)] + input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid - 2 + 4) + xgid + 4)]) + coeffs[hook(2, 3)] * (input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 3 + 4) + xgid + 4)] + input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid - 3 + 4) + xgid + 4)]) + coeffs[hook(2, 4)] * (input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4 + 4) + xgid + 4)] + input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid - 4 + 4) + xgid + 4)])

                  + coeffs[hook(2, 1)] * (f00 + b00) + coeffs[hook(2, 2)] * (f01 + b01) + coeffs[hook(2, 3)] * (f02 + b02) + coeffs[hook(2, 4)] * (f03 + b03);
      output[hook(1, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid + 4)] = current + laplacian;
    }
  }
}