//{"CDF":4,"I":2,"Nparticles":1,"ind":3,"likelihood":7,"partial_sums":0,"seed":6,"weights":5}
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
    likelihoodSum += (pow((double)(I[hook(2, ind[ihook(3, index * numOnes + x))] - 100), 2) - pow((double)(I[hook(2, ind[ihook(3, index * numOnes + x))] - 228), 2)) / 50.0;
  return likelihoodSum;
}

void cdfCalc(global double* CDF, global double* weights, int Nparticles) {
  int x;
  CDF[hook(4, 0)] = weights[hook(5, 0)];
  for (x = 1; x < Nparticles; x++) {
    CDF[hook(4, x)] = weights[hook(5, x)] + CDF[hook(4, x - 1)];
  }
}

double d_randu(global int* seed, int index) {
  int M = 2147483647;
  int A = 1103515245;
  int C = 12345;
  int num = A * seed[hook(6, index)] + C;
  seed[hook(6, index)] = num % M;
  return fabs(seed[hook(6, index)] / ((double)M));
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
    weights[hook(5, x)] = weights[hook(5, x)] * exp(likelihood[hook(7, x)]);
    sum += weights[hook(5, x)];
  }
  return sum;
}

int findIndexBin(global double* CDF, int beginIndex, int endIndex, double value) {
  if (endIndex < beginIndex)
    return -1;
  int middleIndex;
  while (endIndex > beginIndex) {
    middleIndex = beginIndex + ((endIndex - beginIndex) / 2);
    if (CDF[hook(4, middleIndex)] >= value) {
      if (middleIndex == 0)
        return middleIndex;
      else if (CDF[hook(4, middleIndex - 1)] < value)
        return middleIndex;
      else if (CDF[hook(4, middleIndex - 1)] == value) {
        while (CDF[hook(4, middleIndex)] == value && middleIndex >= 0)
          middleIndex--;
        middleIndex++;
        return middleIndex;
      }
    }
    if (CDF[hook(4, middleIndex)] > value)
      endIndex = middleIndex - 1;
    else
      beginIndex = middleIndex + 1;
  }
  return -1;
}
kernel void sum_kernel(global double* partial_sums, int Nparticles) {
  int i = get_global_id(0);
  size_t THREADS_PER_BLOCK = get_local_size(0);

  if (i == 0) {
    int x;
    double sum = 0;
    int num_blocks = ceil((double)Nparticles / (double)THREADS_PER_BLOCK);
    for (x = 0; x < num_blocks; x++) {
      sum += partial_sums[hook(0, x)];
    }
    partial_sums[hook(0, 0)] = sum;
  }
}