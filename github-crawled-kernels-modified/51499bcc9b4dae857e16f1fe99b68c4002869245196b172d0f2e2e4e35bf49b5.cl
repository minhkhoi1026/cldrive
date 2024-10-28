//{"N":1,"result_acosh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_acosh_withDD1(global float* result_acosh, int N) {
  float p1 = 2.0;
  int i = 0;
  for (i = 0; i < N; i++) {
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    p1 += acosh(p1);
    ;
  }
  *result_acosh = p1;
}