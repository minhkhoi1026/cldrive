//{"a":3,"b":4,"changed":2,"dst":5,"mapping":0,"old_mapping":1,"src":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float distsqr(global float* a, global float* b) {
  float result = 0.0f;

  for (int i = 0; i < 3; ++i) {
    result += (a[hook(3, i)] - b[hook(4, i)]) * (a[hook(3, i)] - b[hook(4, i)]);
  }

  return result;
}

float distsqr__(float* a, global float* b) {
  float result = 0.0f;

  for (int i = 0; i < 3; ++i) {
    result += (a[hook(3, i)] - b[hook(4, i)]) * (a[hook(3, i)] - b[hook(4, i)]);
  }

  return result;
}

float distsqr____(global float* a, global float* b) {
  float result = 0.0f;

  for (int i = 0; i < 3; ++i) {
    result += (a[hook(3, i)] - b[hook(4, i)]) * (a[hook(3, i)] - b[hook(4, i)]);
  }

  return result;
}

float distcos(global float* a, global float* b) {
  float result = 0.0f, lena = 0.0f, lenb = 0.0f;

  for (int i = 0; i < 3; ++i) {
    result += a[hook(3, i)] * b[hook(4, i)];
    lena += a[hook(3, i)] * a[hook(3, i)];
    lenb += b[hook(4, i)] * b[hook(4, i)];
  }

  return 1.0f - result / (sqrt(lena) * sqrt(lenb));
}

float disttan(global float* a, global float* b) {
  float result = 0.0f;
  float lena = 0.0f;
  float lenb = 0.0f;

  for (int i = 0; i < 3; ++i) {
    result += a[hook(3, i)] * b[hook(4, i)];
    lena += a[hook(3, i)] * a[hook(3, i)];
    lenb += b[hook(4, i)] * b[hook(4, i)];
  }

  return 1.0f - result / (lena + lenb - result);
}

void copy(local float* dst, global float* src) {
  for (int i = 0; i < 3; ++i) {
    dst[hook(5, i)] = src[hook(6, i)];
  }
}

kernel void compare_mapping(global int* mapping, global int* old_mapping, global int* changed) {
  int id = get_global_id(0);
  if (mapping[hook(0, id)] != old_mapping[hook(1, id)])
    changed[hook(2, 0)] = 1;
}