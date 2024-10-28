//{"N":1,"result_atanh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_atanh_withDD1(global float* result_atanh, int N) {
  float t1 = 0.0;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    t1 = atanh(t1);
    ;
  }
  *result_atanh = t1;
}