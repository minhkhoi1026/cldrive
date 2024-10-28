//{"N":1,"result_powr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_powr_withoutDD1(global float* result_powr, int N) {
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

  float i = 1.0;
  int j = 1;
  float n = 7 * (float)(N);

  for (i = 1.0; i < n; i = i + 1.0) {
    t1 = powr(i, j);
    t2 = powr(i, j);
    t3 = powr(i, j);
    t4 = powr(i, j);
    t5 = powr(i, j);
    t6 = powr(i, j);
    t7 = powr(i, j);
    t8 = powr(i, j);
    t9 = powr(i, j);
    t10 = powr(i, j);
  }
  *result_powr = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}