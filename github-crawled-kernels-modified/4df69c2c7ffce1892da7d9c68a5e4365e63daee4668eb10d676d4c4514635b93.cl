//{"N":1,"result_tanpi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tanpi_withoutDD1(global float* result_tanpi, int N) {
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
    t1 = tanpi(i);
    t2 = tanpi(i);
    t3 = tanpi(i);
    t4 = tanpi(i);
    t5 = tanpi(i);
    t6 = tanpi(i);
    t7 = tanpi(i);
    t8 = tanpi(i);
    t9 = tanpi(i);
    t10 = tanpi(i);
  }
  *result_tanpi = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}