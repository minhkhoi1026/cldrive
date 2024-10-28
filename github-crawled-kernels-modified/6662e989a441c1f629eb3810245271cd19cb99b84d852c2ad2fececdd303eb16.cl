//{"CDF":4,"I":8,"IszY":15,"Nfr":16,"Nparticles":11,"arrayX":0,"arrayY":1,"buffer":19,"countOnes":12,"ind":5,"k":14,"likelihood":7,"max_size":13,"objxy":6,"partial_sums":18,"seed":17,"u":9,"weights":10,"xj":2,"yj":3}
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
    likelihoodSum += (pow((double)(I[hook(8, ind[ihook(5, index * numOnes + x))] - 100), 2) - pow((double)(I[hook(8, ind[ihook(5, index * numOnes + x))] - 228), 2)) / 50.0;
  return likelihoodSum;
}

void cdfCalc(global double* CDF, global double* weights, int Nparticles) {
  int x;
  CDF[hook(4, 0)] = weights[hook(10, 0)];
  for (x = 1; x < Nparticles; x++) {
    CDF[hook(4, x)] = weights[hook(10, x)] + CDF[hook(4, x - 1)];
  }
}

double d_randu(global int* seed, int index) {
  int M = 2147483647;
  int A = 1103515245;
  int C = 12345;
  int num = A * seed[hook(17, index)] + C;
  seed[hook(17, index)] = num % M;
  return fabs(seed[hook(17, index)] / ((double)M));
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
    weights[hook(10, x)] = weights[hook(10, x)] * exp(likelihood[hook(7, x)]);
    sum += weights[hook(10, x)];
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
kernel void likelihood_kernel(global double* arrayX, global double* arrayY, global double* xj, global double* yj, global double* CDF, global int* ind, global int* objxy, global double* likelihood, global unsigned char* I, global double* u, global double* weights, const int Nparticles, const int countOnes, const int max_size, int k, const int IszY, const int Nfr, global int* seed, global double* partial_sums, local double* buffer) {
  int block_id = get_group_id(0);
  int thread_id = get_local_id(0);
  int i = get_global_id(0);
  size_t THREADS_PER_BLOCK = get_local_size(0);
  int y;
  int indX, indY;

  if (i < Nparticles) {
    arrayX[hook(0, i)] = xj[hook(2, i)];
    arrayY[hook(1, i)] = yj[hook(3, i)];

    weights[hook(10, i)] = 1 / ((double)(Nparticles));

    arrayX[hook(0, i)] = arrayX[hook(0, i)] + 1.0 + 5.0 * d_randn(seed, i);
    arrayY[hook(1, i)] = arrayY[hook(1, i)] - 2.0 + 2.0 * d_randn(seed, i);
  }

  barrier(0x02);

  if (i < Nparticles) {
    for (y = 0; y < countOnes; y++) {
      indX = dev_round_double(arrayX[hook(0, i)]) + objxy[hook(6, y * 2 + 1)];
      indY = dev_round_double(arrayY[hook(1, i)]) + objxy[hook(6, y * 2)];

      ind[hook(5, i * countOnes + y)] = abs(indX * IszY * Nfr + indY * Nfr + k);
      if (ind[hook(5, i * countOnes + y)] >= max_size)
        ind[hook(5, i * countOnes + y)] = 0;
    }
    likelihood[hook(7, i)] = calcLikelihoodSum(I, ind, countOnes, i);

    likelihood[hook(7, i)] = likelihood[hook(7, i)] / countOnes;

    weights[hook(10, i)] = weights[hook(10, i)] * exp(likelihood[hook(7, i)]);
  }

  buffer[hook(19, thread_id)] = 0.0;

  barrier(0x01 | 0x02);

  if (i < Nparticles) {
    buffer[hook(19, thread_id)] = weights[hook(10, i)];
  }

  barrier(0x01);

  for (unsigned int s = THREADS_PER_BLOCK / 2; s > 0; s >>= 1) {
    if (thread_id < s) {
      buffer[hook(19, thread_id)] += buffer[hook(19, thread_id + s)];
    }
    barrier(0x01);
  }
  if (thread_id == 0) {
    partial_sums[hook(18, block_id)] = buffer[hook(19, 0)];
  }
}