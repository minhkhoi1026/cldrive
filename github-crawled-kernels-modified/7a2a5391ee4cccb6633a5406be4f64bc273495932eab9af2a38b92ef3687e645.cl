//{"N":1,"result_rootn":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_rootn_withDD2(global float* result_rootn, int N) {
  float2 t1 = 4 + (float2)(0);
  int2 t2 = (int2)(1);
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
  *result_rootn = t1.s0 + t1.s1;
}