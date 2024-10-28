//{"CDF":2,"I":8,"Nparticles":7,"arrayX":0,"arrayY":1,"ind":9,"likelihood":11,"seed":10,"u":3,"weights":6,"xj":4,"yj":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double dev_round_double(double value) {
  int newValue = (int)(value);
  if (value - newValue < .5f)
    return newValue;
  else
    return newValue++;
}
double calcLikelihoodSum(global unsigned char* I, global int* ind, int numOnes, int index) {
  double likelihoodSum = 0.0;
  int x;
  for (x = 0; x < numOnes; x++)
    likelihoodSum += (pow((double)(I[hook(8, ind[ihook(9, index * numOnes + x))] - 100), 2) - pow((double)(I[hook(8, ind[ihook(9, index * numOnes + x))] - 228), 2)) / 50.0;
  return likelihoodSum;
}

void cdfCalc(global double* CDF, global double* weights, int Nparticles) {
  int x;
  CDF[hook(2, 0)] = weights[hook(6, 0)];
  for (x = 1; x < Nparticles; x++) {
    CDF[hook(2, x)] = weights[hook(6, x)] + CDF[hook(2, x - 1)];
  }
}

double d_randu(global int* seed, int index) {
  int M = 2147483647;
  int A = 1103515245;
  int C = 12345;
  int num = A * seed[hook(10, index)] + C;
  seed[hook(10, index)] = num % M;
  return fabs(seed[hook(10, index)] / ((double)M));
}
double d_randn(global int* seed, int index) {
  double pi = 3.14159265358979323846;
  double u = d_randu(seed, index);
  double v = d_randu(seed, index);
  double cosine = cos(2 * pi * v);
  double rt = -2 * log(u);
  return sqrt(rt) * cosine;
}
double updateWeights(global double* weights, global double* likelihood, int Nparticles) {
  int x;
  double sum = 0;
  for (x = 0; x < Nparticles; x++) {
    weights[hook(6, x)] = weights[hook(6, x)] * exp(likelihood[hook(11, x)]);
    sum += weights[hook(6, x)];
  }
  return sum;
}

int findIndexBin(global double* CDF, int beginIndex, int endIndex, double value) {
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
kernel void find_index_kernel(global double* arrayX, global double* arrayY, global double* CDF, global double* u, global double* xj, global double* yj, global double* weights, int Nparticles) {
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
  barrier(0x02);
}