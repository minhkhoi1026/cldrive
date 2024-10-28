//{"N":1,"result_sinh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sinh_withDD1(global float* result_sinh, int N) {
  float t1 = 0.0;

  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    t1 = sinh(t1);
    ;
  }
  *result_sinh = t1;
}