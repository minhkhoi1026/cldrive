//{"N":1,"result_rootn":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_rootn_withDD8(global float* result_rootn, int N) {
  float8 t1 = 4 + (float8)(0);
  int8 t2 = (int8)(1);
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    ;
  }
  *result_rootn = t1.s0 + t1.s1 + t1.s2 + t1.s3 + t1.s4 + t1.s5 + t1.s6 + t1.s7;
}