//{"N":1,"result_atan2":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_atan2_withDD1(global float* result_atan2, int N) {
  float t1 = 12345.64;
  float t2 = 0.01;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    t1 = atan2(t1, t2);
    ;
  }
  *result_atan2 = t1;
}