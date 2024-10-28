//{"N":1,"result_atan":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_atan_withDD1(global float* result_atan, int N) {
  float t1 = 1.23;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    t1 = atan(t1);
    ;
  }
  *result_atan = t1;
}