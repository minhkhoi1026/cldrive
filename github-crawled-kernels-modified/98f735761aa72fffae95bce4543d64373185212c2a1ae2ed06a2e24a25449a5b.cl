//{"N":1,"result_cos":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_cos_withDD1(global float* result_cos, int N) {
  float t1 = 1.23;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    t1 = cos(t1);
    ;
  }
  *result_cos = t1;
}