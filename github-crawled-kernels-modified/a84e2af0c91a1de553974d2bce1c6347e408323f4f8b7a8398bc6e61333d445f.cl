//{"CDF":3,"I":6,"Nparticles":1,"ind":7,"likelihood":8,"partial_sums":2,"seed":5,"u":4,"weights":0}
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
    likelihoodSum += (pow((double)(I[hook(6, ind[ihook(7, index * numOnes + x))] - 100), 2) - pow((double)(I[hook(6, ind[ihook(7, index * numOnes + x))] - 228), 2)) / 50.0;
  return likelihoodSum;
}

void cdfCalc(global double* CDF, global double* weights, int Nparticles) {
  int x;
  CDF[hook(3, 0)] = weights[hook(0, 0)];
  for (x = 1; x < Nparticles; x++) {
    CDF[hook(3, x)] = weights[hook(0, x)] + CDF[hook(3, x - 1)];
  }
}

double d_randu(global int* seed, int index) {
  int M = 2147483647;
  int A = 1103515245;
  int C = 12345;
  int num = A * seed[hook(5, index)] + C;
  seed[hook(5, index)] = num % M;
  return fabs(seed[hook(5, index)] / ((double)M));
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
    weights[hook(0, x)] = weights[hook(0, x)] * exp(likelihood[hook(8, x)]);
    sum += weights[hook(0, x)];
  }
  return sum;
}

int findIndexBin(global double* CDF, int beginIndex, int endIndex, double value) {
  if (endIndex < beginIndex)
    return -1;
  int middleIndex;
  while (endIndex > beginIndex) {
    middleIndex = beginIndex + ((endIndex - beginIndex) / 2);
    if (CDF[hook(3, middleIndex)] >= value) {
      if (middleIndex == 0)
        return middleIndex;
      else if (CDF[hook(3, middleIndex - 1)] < value)
        return middleIndex;
      else if (CDF[hook(3, middleIndex - 1)] == value) {
        while (CDF[hook(3, middleIndex)] == value && middleIndex >= 0)
          middleIndex--;
        middleIndex++;
        return middleIndex;
      }
    }
    if (CDF[hook(3, middleIndex)] > value)
      endIndex = middleIndex - 1;
    else
      beginIndex = middleIndex + 1;
  }
  return -1;
}
kernel void normalize_weights_kernel(global double* weights, int Nparticles, global double* partial_sums, global double* CDF, global double* u, global int* seed) {
  int i = get_global_id(0);
  int local_id = get_local_id(0);
  local double u1;
  local double sumWeights;

  if (0 == local_id)
    sumWeights = partial_sums[hook(2, 0)];

  barrier(0x01);

  if (i < Nparticles) {
    weights[hook(0, i)] = weights[hook(0, i)] / sumWeights;
  }

  barrier(0x02);

  if (i == 0) {
    cdfCalc(CDF, weights, Nparticles);
    u[hook(4, 0)] = (1 / ((double)(Nparticles))) * d_randu(seed, i);
  }

  barrier(0x02);

  if (0 == local_id)
    u1 = u[hook(4, 0)];

  barrier(0x01);

  if (i < Nparticles) {
    u[hook(4, i)] = u1 + i / ((double)(Nparticles));
  }
}