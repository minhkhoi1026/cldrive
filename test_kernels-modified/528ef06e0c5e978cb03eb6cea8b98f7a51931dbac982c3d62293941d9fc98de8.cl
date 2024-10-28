//{"CDF":4,"I":8,"IszY":15,"Nfr":16,"Nparticles":11,"arrayX":0,"arrayY":1,"buffer":19,"countOnes":12,"ind":5,"k":14,"likelihood":7,"max_size":13,"objxy":6,"partial_sums":18,"seed":17,"u":9,"weights":10,"xj":2,"yj":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float dev_round_float(float value) {
  int newValue = (int)(value);
  if (value - newValue < .5f)
    return newValue;
  else
    return newValue++;
}
float calcLikelihoodSum(global unsigned char* I, global int* ind, int numOnes, int index) {
  float likelihoodSum = 0.0;
  int x;
  for (x = 0; x < numOnes; x++)
    likelihoodSum += (pow((float)(I[hook(8, ind[ihook(5, index * numOnes + x))] - 100), 2) - pow((float)(I[hook(8, ind[ihook(5, index * numOnes + x))] - 228), 2)) / 50.0;
  return likelihoodSum;
}

void cdfCalc(global float* CDF, global float* weights, int Nparticles) {
  int x;
  CDF[hook(4, 0)] = weights[hook(10, 0)];
  for (x = 1; x < Nparticles; x++) {
    CDF[hook(4, x)] = weights[hook(10, x)] + CDF[hook(4, x - 1)];
  }
}

float d_randu(global int* seed, int index) {
  int M = 2147483647;
  int A = 1103515245;
  int C = 12345;
  int num = A * seed[hook(17, index)] + C;
  seed[hook(17, index)] = num % M;
  return fabs(seed[hook(17, index)] / ((float)M));
}
float d_randn(global int* seed, int index) {
  float pi = 3.14159265358979323846;
  float u = d_randu(seed, index);
  float v = d_randu(seed, index);
  float cosine = cos(2 * pi * v);
  float rt = -2 * log(u);
  return sqrt(rt) * cosine;
}
float updateWeights(global float* weights, global float* likelihood, int Nparticles) {
  int x;
  float sum = 0;
  for (x = 0; x < Nparticles; x++) {
    weights[hook(10, x)] = weights[hook(10, x)] * exp(likelihood[hook(7, x)]);
    sum += weights[hook(10, x)];
  }
  return sum;
}

int findIndexBin(global float* CDF, int beginIndex, int endIndex, float value) {
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

float tex1Dfetch(read_only image2d_t img, int index) {
  const sampler_t smp = 0 | 4 | 0x10;

  if (index < 0)
    return 0;

  int imgPos = index >> 2;

  int2 coords;
  coords.x = imgPos >> 13;
  coords.y = imgPos & 0x1fff;
  float4 temp = read_imagef(img, smp, coords);

  imgPos = index & 0x0003;

  if (imgPos < 2) {
    if (imgPos == 0)
      return temp.x;
    else
      return temp.y;
  } else {
    if (imgPos == 2)
      return temp.z;
    else
      return temp.w;
  }
}
kernel void likelihood_kernel(global float* arrayX, global float* arrayY, global float* xj, global float* yj, global float* CDF, global int* ind, global int* objxy, global float* likelihood, global unsigned char* I, global float* u, global float* weights, const int Nparticles, const int countOnes, const int max_size, int k, const int IszY, const int Nfr, global int* seed, global float* partial_sums, local float* buffer) {
  int block_id = get_group_id(0);
  int thread_id = get_local_id(0);
  int i = get_global_id(0);
  size_t THREADS_PER_BLOCK = get_local_size(0);
  int y;
  int indX, indY;

  if (i < Nparticles) {
    arrayX[hook(0, i)] = xj[hook(2, i)];
    arrayY[hook(1, i)] = yj[hook(3, i)];

    weights[hook(10, i)] = 1 / ((float)(Nparticles));

    arrayX[hook(0, i)] = arrayX[hook(0, i)] + 1.0 + 5.0 * d_randn(seed, i);
    arrayY[hook(1, i)] = arrayY[hook(1, i)] - 2.0 + 2.0 * d_randn(seed, i);
  }

  barrier(0x02);

  if (i < Nparticles) {
    for (y = 0; y < countOnes; y++) {
      indX = dev_round_float(arrayX[hook(0, i)]) + objxy[hook(6, y * 2 + 1)];
      indY = dev_round_float(arrayY[hook(1, i)]) + objxy[hook(6, y * 2)];

      ind[hook(5, i * countOnes + y)] = abs(indX * IszY * Nfr + indY * Nfr + k);
      if (ind[hook(5, i * countOnes + y)] >= max_size)
        ind[hook(5, i * countOnes + y)] = 0;
    }
    likelihood[hook(7, i)] = calcLikelihoodSum(I, ind, countOnes, i);

    likelihood[hook(7, i)] = likelihood[hook(7, i)] / countOnes - 300;

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