//{"N":1,"result_remquo":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_remquo_withoutDD1(global float* result_remquo, int N) {
  float t1;
  float t2;
  float t3;
  float t4;
  float t5;
  float t6;
  float t7;

  float i = 1.0;
  float j = 1.0;

  int a = 0;
  int* t = &a;
  float n = (float)(N);
  for (i = 1.0; i < n; i = i + 1.0) {
    t1 = remquo(i, j, t);
    t2 = remquo(i, j, t);
    t3 = remquo(i, j, t);
    t4 = remquo(i, j, t);
    t5 = remquo(i, j, t);
    t6 = remquo(i, j, t);
    t7 = remquo(i, j, t);
  }
  *result_remquo = t1 + t2 + t3 + t4 + t5 + t6 + t7;
}