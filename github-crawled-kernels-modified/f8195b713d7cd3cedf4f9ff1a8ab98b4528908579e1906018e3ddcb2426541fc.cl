//{"LMatrix":0,"d":2,"inplaceMatrix":1,"ratio":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelLUDecompose(global double4* LMatrix, global double4* inplaceMatrix, int d, local double* ratio) {
  int y = get_global_id(1);
  int x = get_global_id(0);
  int lidx = get_local_id(0);
  int lidy = get_local_id(1);

  int xdimension = get_global_size(0) + d / 4;
  int D = d % 4;

  if (get_local_id(0) == 0) {
    (D == 0) ? (ratio[hook(3, lidy)] = inplaceMatrix[hook(1, y * xdimension + d / 4)].s0 / inplaceMatrix[hook(1, d * xdimension + d / 4)].s0) : 1;
    (D == 1) ? (ratio[hook(3, lidy)] = inplaceMatrix[hook(1, y * xdimension + d / 4)].s1 / inplaceMatrix[hook(1, d * xdimension + d / 4)].s1) : 1;
    (D == 2) ? (ratio[hook(3, lidy)] = inplaceMatrix[hook(1, y * xdimension + d / 4)].s2 / inplaceMatrix[hook(1, d * xdimension + d / 4)].s2) : 1;
    (D == 3) ? (ratio[hook(3, lidy)] = inplaceMatrix[hook(1, y * xdimension + d / 4)].s3 / inplaceMatrix[hook(1, d * xdimension + d / 4)].s3) : 1;
  }

  barrier(0x01);

  if (y >= d + 1 && ((x + 1) * 4) > d) {
    double4 result;

    {
      result.s0 = inplaceMatrix[hook(1, y * xdimension + x)].s0 - ratio[hook(3, lidy)] * inplaceMatrix[hook(1, d * xdimension + x)].s0;
      result.s1 = inplaceMatrix[hook(1, y * xdimension + x)].s1 - ratio[hook(3, lidy)] * inplaceMatrix[hook(1, d * xdimension + x)].s1;
      result.s2 = inplaceMatrix[hook(1, y * xdimension + x)].s2 - ratio[hook(3, lidy)] * inplaceMatrix[hook(1, d * xdimension + x)].s2;
      result.s3 = inplaceMatrix[hook(1, y * xdimension + x)].s3 - ratio[hook(3, lidy)] * inplaceMatrix[hook(1, d * xdimension + x)].s3;
    }

    if (x == d / 4) {
      (D == 0) ? (LMatrix[hook(0, y * xdimension + x)].s0 = ratio[hook(3, lidy)]) : (inplaceMatrix[hook(1, y * xdimension + x)].s0 = result.s0);
      (D == 1) ? (LMatrix[hook(0, y * xdimension + x)].s1 = ratio[hook(3, lidy)]) : (inplaceMatrix[hook(1, y * xdimension + x)].s1 = result.s1);
      (D == 2) ? (LMatrix[hook(0, y * xdimension + x)].s2 = ratio[hook(3, lidy)]) : (inplaceMatrix[hook(1, y * xdimension + x)].s2 = result.s2);
      (D == 3) ? (LMatrix[hook(0, y * xdimension + x)].s3 = ratio[hook(3, lidy)]) : (inplaceMatrix[hook(1, y * xdimension + x)].s3 = result.s3);
    } else {
      inplaceMatrix[hook(1, y * xdimension + x)].s0 = result.s0;
      inplaceMatrix[hook(1, y * xdimension + x)].s1 = result.s1;
      inplaceMatrix[hook(1, y * xdimension + x)].s2 = result.s2;
      inplaceMatrix[hook(1, y * xdimension + x)].s3 = result.s3;
    }
  }
}