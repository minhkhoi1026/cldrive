//{"N":1,"result_rootn":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_rootn_withDD1(global float* result_rootn, int N) {
  float t1 = 4;
  int t2 = 1;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    t1 = rootn(t1, t2);
    ;
  }
  *result_rootn = t1;
}