//{"K":2,"M":0,"N":1,"a":3,"b":4,"c":5,"c_r":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm(const int M, const int N, const int K, global const float8* a, global const float8* b, global float8* c) {
  float8 c_r[8] = {0, 0, 0, 0, 0, 0, 0, 0};

  int const a_off_thr = get_global_id(0);
  int const b_off_thr = get_global_id(1);

  int a_off = a_off_thr;
  int b_off = b_off_thr;
  for (int k = 0; k < 1024; k += 1) {
    float8 a_r = a[hook(3, a_off)];
    float8 b_r = b[hook(4, b_off)];

    c_r[hook(6, 0)] += a_r.s0 * b_r;
    c_r[hook(6, 1)] += a_r.s1 * b_r;
    c_r[hook(6, 2)] += a_r.s2 * b_r;
    c_r[hook(6, 3)] += a_r.s3 * b_r;
    c_r[hook(6, 4)] += a_r.s4 * b_r;
    c_r[hook(6, 5)] += a_r.s5 * b_r;
    c_r[hook(6, 6)] += a_r.s6 * b_r;
    c_r[hook(6, 7)] += a_r.s7 * b_r;

    a_off += 128;
    b_off += 128;
  }

  int c_off = a_off_thr * 1024 + b_off_thr;
  for (int i = 0; i < 8; i++) {
    c[hook(5, c_off)] = c_r[hook(6, i)];
    c_off += 128;
  }
}