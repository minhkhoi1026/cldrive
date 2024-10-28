//{"N":1,"result_erfc":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_erfc_withDD1(global float* result_erfc, int N) {
  float t1 = 1.0;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    t1 = erfc(t1);
    ;
  }
  *result_erfc = t1;
}