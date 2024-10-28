//{"N":1,"result_acos":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_acos_withDD1(global float* result_acos, int N) {
  float t1 = 0.0;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    t1 = acos(t1 * 0.5);
    ;
  }
  *result_acos = t1;
}