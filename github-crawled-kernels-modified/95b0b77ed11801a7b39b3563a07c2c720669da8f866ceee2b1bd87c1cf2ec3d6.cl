//{"N":1,"result_cospi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_cospi_withoutDD1(global float* result_cospi, int N) {
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
  float n = (float)(N);
  for (i = 0.0; i < n; i = i + 0.1) {
    t1 = cospi(i);
    t2 = cospi(i);
    t3 = cospi(i);
    t4 = cospi(i);
    t5 = cospi(i);
    t6 = cospi(i);
    t7 = cospi(i);
    t8 = cospi(i);
    t9 = cospi(i);
    t10 = cospi(i);
  }
  *result_cospi = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}