//{"N":1,"result_modf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_modf_withDD1(global float* result_modf, int N) {
  float t1 = 1.2;
  float t2;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    t1 = modf(t1, &t2);
    ;
  }
  *result_modf = t1;
}