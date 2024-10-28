//{"N":1,"result_sin":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sin_withDD1(global float* result_sin, int N) {
  float t1 = 1.0;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    t1 = sin(t1);
    ;
  }
  *result_sin = t1;
}