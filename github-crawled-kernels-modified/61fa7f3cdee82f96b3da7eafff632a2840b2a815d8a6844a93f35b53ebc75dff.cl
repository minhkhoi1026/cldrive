//{"N":1,"result_powr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_powr_withDD1(global float* result_powr, int N) {
  float t1 = 4.3;
  float t2 = 1.1;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    t1 = powr(t1, t2);
    ;
  }
  *result_powr = t1;
}