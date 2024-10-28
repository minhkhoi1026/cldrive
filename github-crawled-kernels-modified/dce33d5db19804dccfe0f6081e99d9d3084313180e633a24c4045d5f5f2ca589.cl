//{"N":2,"p1":0,"result_div":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_div_withDD1(float p1, global float* result_div, int N) {
  float t1 = 1.0;
  float t2 = p1;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    t1 /= t2;
    ;
  }
  *result_div = t1 + t2;
}