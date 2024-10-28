//{"dataLength":1,"errorSumOut":6,"lim0":2,"lim1":3,"nonExceedanceSumOut":7,"observed":4,"simulated":5,"stride":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void eval(unsigned int stride, unsigned int dataLength, unsigned int lim0, unsigned int lim1, global const float* observed, global const float* simulated, global float* errorSumOut, global int* nonExceedanceSumOut) {
  int gId0 = get_global_id(0);
  int gId1 = get_global_id(1);
  int lId0 = get_local_id(0);
  int lId1 = get_local_id(1);
  int gDataRow;

  int gSimulatedRow;
  int gOutRow;

  float errorSum = 0;
  int notExceededSum = 0;

  gDataRow = gId0 * stride;

  gSimulatedRow = gId1 * dataLength + gId0 * stride;
  gOutRow = gId1 * (get_global_size(0)) + gId0;

  if (gId1 < lim1 && gId0 < (lim0 - 1)) {
    for (int i0 = 0; i0 < stride; i0++) {
      errorSum += pow(observed[hook(4, gDataRow + i0)] - simulated[hook(5, gSimulatedRow + i0)], 2);
      notExceededSum += observed[hook(4, gDataRow + i0)] <= simulated[hook(5, gSimulatedRow + i0)];
    }

    errorSumOut[hook(6, gOutRow)] = errorSum;
    nonExceedanceSumOut[hook(7, gOutRow)] = notExceededSum;
  } else if (gId1 < lim1 && gId0 < lim0) {
    for (int i0 = 0; gDataRow + i0 < dataLength; i0++) {
      errorSum += pow(observed[hook(4, gDataRow + i0)] - simulated[hook(5, gSimulatedRow + i0)], 2);
      notExceededSum += observed[hook(4, gDataRow + i0)] <= simulated[hook(5, gSimulatedRow + i0)];
    }

    errorSumOut[hook(6, gOutRow)] = errorSum;
    nonExceedanceSumOut[hook(7, gOutRow)] = notExceededSum;
  }
}