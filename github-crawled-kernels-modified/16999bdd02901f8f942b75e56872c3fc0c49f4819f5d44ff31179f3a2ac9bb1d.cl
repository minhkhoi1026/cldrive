//{"N":1,"result_logb":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_logb_withDD1(global float* result_logb, int N) {
  float t1 = 10.0;

  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    t1 = 4.0 + logb(t1);
    ;
  }
  *result_logb = t1;
}