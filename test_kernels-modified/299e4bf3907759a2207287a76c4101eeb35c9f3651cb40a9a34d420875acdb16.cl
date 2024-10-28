//{"bucketNum":2,"buckets":3,"randomNums":0,"randoms":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int stepLCG(unsigned int* z, unsigned int A, unsigned int C) {
  return (*z) = (A * (*z) + C);
}

unsigned int stepLFG(unsigned int* z, global unsigned int* znmk, unsigned int A, unsigned int C) {
  return (*znmk) = (*z) = (A * (*z) + C) + (*znmk);
}

unsigned int stepCTG(unsigned int* z, unsigned int S1, unsigned int S2, unsigned int S3, unsigned int M) {
  unsigned int b = ((((*z) << S1) ^ (*z)) >> S2);
  return (*z) = ((((*z) & M) << S3) ^ b);
}

float stepHybrid(unsigned int* rng1, unsigned int* rng2, unsigned int* rng3, unsigned int* rng4) {
  return 2.3283064365387e-10 * (stepCTG(rng1, 13, 19, 12, 4294967294UL) ^ stepCTG(rng2, 2, 25, 4, 4294967288UL) ^ stepCTG(rng3, 3, 11, 17, 4294967280UL) ^ stepLCG(rng4, 1664525, 1013904223UL));
}

float stepHalton(float* value, float inv_base) {
  float r = 1.0 - (*value) - 0.0000000001;
  if (inv_base < r) {
    (*value) += inv_base;
  } else {
    float h = inv_base, hh;
    do {
      hh = h;
      h *= inv_base;
    } while (h >= r);
    (*value) += hh + h - 1.0;
  }
  return (*value);
}

void seedHalton(ulong i, int base, float* inv_base, float* value) {
  float f = (*inv_base) = 1.0 / base;
  (*value) = 0.0;
  while (i > 0) {
    (*value) += f * (float)(i % base);
    i /= base;
    f *= (*inv_base);
  }
}

kernel void testUniform1D(const int randomNums, global float* randoms, const int bucketNum, global int* buckets) {
  int id = get_local_id(0);
  int maxID = get_global_size(0);

  for (int i = 0; i < bucketNum; ++i) {
    buckets[hook(3, id + i * maxID)] = 0;
  }

  for (int i = 0; i < randomNums; ++i) {
    int bucket = floor(randoms[hook(1, id + i * maxID)] / (1.0 / bucketNum));
    buckets[hook(3, id + bucket * maxID)] += 1;
  }
}