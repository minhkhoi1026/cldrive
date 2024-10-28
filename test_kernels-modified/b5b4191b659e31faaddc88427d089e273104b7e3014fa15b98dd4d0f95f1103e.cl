//{"CDF":2,"Nparticles":6,"arrayX":0,"arrayY":1,"u":3,"xj":4,"yj":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int findIndexSeq(double* CDF, int lengthCDF, double value) {
  int index = -1;
  int x;
  for (x = 0; x < lengthCDF; x++) {
    if (CDF[hook(2, x)] >= value) {
      index = x;
      break;
    }
  }
  if (index == -1)
    return lengthCDF - 1;
  return index;
}

int findIndexBin(double* CDF, int beginIndex, int endIndex, double value) {
  if (endIndex < beginIndex)
    return -1;
  int middleIndex;
  while (endIndex > beginIndex) {
    middleIndex = beginIndex + ((endIndex - beginIndex) / 2);
    if (CDF[hook(2, middleIndex)] >= value) {
      if (middleIndex == 0)
        return middleIndex;
      else if (CDF[hook(2, middleIndex - 1)] < value)
        return middleIndex;
      else if (CDF[hook(2, middleIndex - 1)] == value) {
        while (CDF[hook(2, middleIndex)] == value && middleIndex >= 0)
          middleIndex--;
        middleIndex++;
        return middleIndex;
      }
    }
    if (CDF[hook(2, middleIndex)] > value)
      endIndex = middleIndex - 1;
    else
      beginIndex = middleIndex + 1;
  }
  return -1;
}
kernel void particle_kernel(global double* arrayX, global double* arrayY, global double* CDF, global double* u, global double* xj, global double* yj, int Nparticles) {
  int i = get_global_id(0);

  if (i < Nparticles) {
    int index = -1;
    int x;

    for (x = 0; x < Nparticles; x++) {
      if (CDF[hook(2, x)] >= u[hook(3, i)]) {
        index = x;
        break;
      }
    }
    if (index == -1) {
      index = Nparticles - 1;
    }

    xj[hook(4, i)] = arrayX[hook(0, index)];
    yj[hook(5, i)] = arrayY[hook(1, index)];
  }
}