//{"CDF":2,"I":8,"Nparticles":7,"arrayX":0,"arrayY":1,"ind":9,"likelihood":11,"seed":10,"u":3,"weights":6,"xj":4,"yj":5}
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
    likelihoodSum += (pow((float)(I[hook(8, ind[ihook(9, index * numOnes + x))] - 100), 2) - pow((float)(I[hook(8, ind[ihook(9, index * numOnes + x))] - 228), 2)) / 50.0;
  return likelihoodSum;
}

void cdfCalc(global float* CDF, global float* weights, int Nparticles) {
  int x;
  CDF[hook(2, 0)] = weights[hook(6, 0)];
  for (x = 1; x < Nparticles; x++) {
    CDF[hook(2, x)] = weights[hook(6, x)] + CDF[hook(2, x - 1)];
  }
}

float d_randu(global int* seed, int index) {
  int M = 2147483647;
  int A = 1103515245;
  int C = 12345;
  int num = A * seed[hook(10, index)] + C;
  seed[hook(10, index)] = num % M;
  return fabs(seed[hook(10, index)] / ((float)M));
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
    weights[hook(6, x)] = weights[hook(6, x)] * exp(likelihood[hook(11, x)]);
    sum += weights[hook(6, x)];
  }
  return sum;
}

int findIndexBin(global float* CDF, int beginIndex, int endIndex, float value) {
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
kernel void find_index_kernel(global float* arrayX, global float* arrayY, global float* CDF, global float* u, global float* xj, global float* yj, global float* weights, int Nparticles) {
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