//{"N":1,"result_sub":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sub_withDD1(global float* result_sub, int N) {
  float t1 = 99999.9;
  float t2 = 0.1;
  int i = 0;

  for (i = 0; i < N; i++) {
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    t1 -= t2;
    ;
  }

  *result_sub = t1;
}