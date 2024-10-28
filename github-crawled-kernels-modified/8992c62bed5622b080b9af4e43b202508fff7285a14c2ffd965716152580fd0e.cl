//{"N":1,"result_logb":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_logb_withoutDD1(global float* result_logb, int N) {
  float t1;
  float t2;
  float t3;
  float t4;
  float t5;
  float t6;
  float t7;
  float t8;
  float t9;
  float t10;

  float i = 0.0;
  float n = 30.0 * (float)(N);

  for (i = 0.0; i < n; i = i + 1.0) {
    t1 = logb(i);
    t2 = logb(i);
    t3 = logb(i);
    t4 = logb(i);
    t5 = logb(i);
    t6 = logb(i);
    t7 = logb(i);
    t8 = logb(i);
    t9 = logb(i);
    t10 = logb(i);
  }
  *result_logb = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}