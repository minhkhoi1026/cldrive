//{"N":1,"result_atanh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_atanh_withoutDD1(global float* result_atanh, int N) {
  float t1 = 1.2;
  float t2 = 1.2;
  float t3 = 1.2;
  float t4 = 1.2;
  float t5 = 1.2;
  float t6 = 1.2;
  float t7 = 1.2;
  float t8 = 1.2;
  float t9 = 1.2;
  float t10 = 1.2;

  float i = -1.0;

  for (i = -1.0; i <= 1.0; i = i + 0.001) {
    t1 = atanh(i);
    t2 = atanh(i);
    t3 = atanh(i);
    t4 = atanh(i);
    t5 = atanh(i);
    t6 = atanh(i);
    t7 = atanh(i);
    t8 = atanh(i);
    t9 = atanh(i);
    t10 = atan(i);
  }
  *result_atanh = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}