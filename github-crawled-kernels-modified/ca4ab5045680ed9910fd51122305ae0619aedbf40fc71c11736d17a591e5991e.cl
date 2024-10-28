//{"N":1,"result_add":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_add_withoutDD1(global float* result_add, int N) {
  float t1 = 0.1;
  float t2 = 0.1;
  float t3 = 0.1;
  float t4 = 0.2;
  float t5 = 0.1;
  float t6 = 0.1;
  float t7 = 0.1;
  float t8 = 0.2;
  float t9 = 0.1;
  float t10 = 0.1;
  float t11 = 0.1;
  float t12 = 0.2;
  float t13 = 0.1;
  float t14 = 0.1;
  float t15 = 0.2;
  ;
  float i = 0;
  float p = N;
  for (i = 0.0; i < p; i = i + 1.0) {
    t1 += i;
    t2 += i;
    t3 += i;
    t4 += i;
    t5 += i;
    t6 += i;
    t7 += i;
    t8 += i;
    t9 += i;
    t10 += i;
    t11 += i;
    t12 += i;
    t13 += i;
    t14 += i;
    t15 += i;
  }

  *result_add = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12 + t13 + t14 + t15;
}