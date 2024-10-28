//{"C":4,"Cgen":5,"d_CDist":2,"d_COccu":3,"d_Cell":0,"d_Rdom":1,"matrix":7,"transfer":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int DNH[9] = {1, 1, 1, 1, 0, 1, 1, 1, 1};

constant int GNH[9] = {1, 1, 1, 1, 0, 1, 1, 1, 1};

void CheckCellValue(global float* C, global float* Cgen, int condition, int current) {
  if (C[hook(4, current)] == condition)
    Cgen[hook(5, current)] = 1;
  else
    Cgen[hook(5, current)] = 0;
}

float Neighbourhood_filter(constant int* transfer, global float* matrix, int current) {
  return (transfer[hook(6, 0)] * matrix[hook(7, current - 1 - (128 * 16))] + transfer[hook(6, 1)] * matrix[hook(7, current - (128 * 16))] + transfer[hook(6, 2)] * matrix[hook(7, current - (128 * 16) + 1)] + transfer[hook(6, 3)] * matrix[hook(7, current - 1)] + transfer[hook(6, 4)] * matrix[hook(7, current)] + transfer[hook(6, 5)] * matrix[hook(7, current + 1)] + transfer[hook(6, 6)] * matrix[hook(7, current - 1 + (128 * 16))] + transfer[hook(6, 7)] * matrix[hook(7, current + (128 * 16))] + transfer[hook(6, 8)] * matrix[hook(7, current + 1 + (128 * 16))]);
}

kernel void MusselDisturbKernel(global float* d_Cell, global float* d_Rdom, global float* d_CDist, global float* d_COccu) {
  int Nu0;
  float N;

  float Colonization;
  float Erosion;
  float BecomeEmpty;

  size_t current = get_global_id(0);

  int row = floor((float)current / (float)(128 * 16));
  int column = current % (128 * 16);

  CheckCellValue(d_Cell, d_COccu, 2, current);

  CheckCellValue(d_Cell, d_CDist, 0, current);

  barrier(0x02);

  if (row > 0 && row < (128 * 16) - 1 && column > 0 && column < (128 * 16) - 1) {
    if (Neighbourhood_filter(DNH, d_CDist, current) > 0.0f)
      Nu0 = 1;
    else
      Nu0 = 0;

    N = (float)(Neighbourhood_filter(GNH, d_COccu, current)) / 8.0f;

    if ((d_COccu[hook(3, current)] == 1) && (d_Rdom[hook(1, current)] <= (float)(0.9 * Nu0 + 0.002)))
      Erosion = -2;
    else
      Erosion = 0;

    if (!d_COccu[hook(3, current)] && !d_CDist[hook(2, current)] && (d_Rdom[hook(1, current)] <= (float)(N * 0.6)))
      Colonization = +1;
    else
      Colonization = 0;

    if (d_CDist[hook(2, current)] == 1)
      BecomeEmpty = 1;
    else
      BecomeEmpty = 0;

    d_Cell[hook(0, current)] = d_Cell[hook(0, current)] + Colonization + Erosion + BecomeEmpty;
  }
}