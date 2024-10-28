//{"N":1,"result_acosh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_acosh_withoutDD1(global float* result_acosh, int N) {
  float p1 = 1.23;
  float p2 = 1.23;
  float p3 = 1.23;
  float p4 = 1.23;
  float p5 = 1.23;
  float p6 = 1.23;
  float p7 = 1.23;
  float p8 = 1.23;
  float p9 = 1.23;
  float p10 = 1.23;

  float i = 0.0;
  float n = N + 1.0;

  for (i = 0.0; i < n; i = i + 0.1) {
    p1 = acosh(i);
    p2 = acosh(i);
    p3 = acosh(i);
    p4 = acosh(i);
    p5 = acosh(i);
    p6 = acosh(i);
    p7 = acosh(i);
    p8 = acosh(i);
    p9 = acosh(i);
    p10 = acosh(i);
  }
  *result_acosh = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10;
}