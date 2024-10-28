//{"a":4,"b":5,"centroids":1,"dst":6,"input":0,"mapping":2,"reduction":3,"src":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float distsqr(global float* a, global float* b) {
  float result = 0.0f;

  for (int i = 0; i < 3; ++i) {
    result += (a[hook(4, i)] - b[hook(5, i)]) * (a[hook(4, i)] - b[hook(5, i)]);
  }

  return result;
}

float distsqr__(float* a, global float* b) {
  float result = 0.0f;

  for (int i = 0; i < 3; ++i) {
    result += (a[hook(4, i)] - b[hook(5, i)]) * (a[hook(4, i)] - b[hook(5, i)]);
  }

  return result;
}

float distsqr____(global float* a, global float* b) {
  float result = 0.0f;

  for (int i = 0; i < 3; ++i) {
    result += (a[hook(4, i)] - b[hook(5, i)]) * (a[hook(4, i)] - b[hook(5, i)]);
  }

  return result;
}

float distcos(global float* a, global float* b) {
  float result = 0.0f, lena = 0.0f, lenb = 0.0f;

  for (int i = 0; i < 3; ++i) {
    result += a[hook(4, i)] * b[hook(5, i)];
    lena += a[hook(4, i)] * a[hook(4, i)];
    lenb += b[hook(5, i)] * b[hook(5, i)];
  }

  return 1.0f - result / (sqrt(lena) * sqrt(lenb));
}

float disttan(global float* a, global float* b) {
  float result = 0.0f;
  float lena = 0.0f;
  float lenb = 0.0f;

  for (int i = 0; i < 3; ++i) {
    result += a[hook(4, i)] * b[hook(5, i)];
    lena += a[hook(4, i)] * a[hook(4, i)];
    lenb += b[hook(5, i)] * b[hook(5, i)];
  }

  return 1.0f - result / (lena + lenb - result);
}

void copy(local float* dst, global float* src) {
  for (int i = 0; i < 3; ++i) {
    dst[hook(6, i)] = src[hook(7, i)];
  }
}

kernel void compute_cost(global float* input, global float* centroids, global int* mapping, global float* reduction) {
  int id = get_global_id(0);
  reduction[hook(3, id)] = distsqr____(&input[hook(0, id * 3)], &centroids[hook(1, mapping[ihook(2, id) * 3)]);
}