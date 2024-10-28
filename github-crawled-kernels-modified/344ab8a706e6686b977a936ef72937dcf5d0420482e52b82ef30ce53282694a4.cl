//{"a":0,"b":1,"c":4,"d":5,"n":3,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float concat1Jaccard(global unsigned int* a, global unsigned int* b, global unsigned int* c, global unsigned int* d) {
  float jacc = 0.0;

  int A_union_C = 0;
  int B_union_D = 0;
  int A_and_not_C = 0;
  int D_and_not_B = 0;
  int C_and_not_A = 0;
  int B_and_not_D = 0;

  int A_intersect_C = 0;
  int B_intersect_D = 0;

  for (int i = 0; i < 8; i++) {
    A_union_C += popcount(a[hook(0, i)] | c[hook(4, i)]);

    B_union_D += popcount(b[hook(1, i)] | d[hook(5, i)]);

    A_and_not_C += popcount(a[hook(0, i)] & (~c[hook(4, i)]));

    D_and_not_B += popcount(d[hook(5, i)] & (~b[hook(1, i)]));

    C_and_not_A += popcount(c[hook(4, i)] & (~a[hook(0, i)]));
    B_and_not_D += popcount(b[hook(1, i)] & (~d[hook(5, i)]));

    A_intersect_C += popcount(a[hook(0, i)] & c[hook(4, i)]);
    B_intersect_D += popcount(b[hook(1, i)] & d[hook(5, i)]);
  }

  int unionBits = (A_union_C * B_union_D) - (A_and_not_C * D_and_not_B) - (C_and_not_A * B_and_not_D);
  int intersectBits = A_intersect_C * B_intersect_D;
  jacc = (float)intersectBits / (float)unionBits;

  return jacc;
}

kernel void add_floats(global const float* a, global const float* b, global float* out, int n) {
  int i = get_global_id(0);
  if (i >= n)
    return;

  out[hook(2, i)] = a[hook(0, i)] + b[hook(1, i)];
}