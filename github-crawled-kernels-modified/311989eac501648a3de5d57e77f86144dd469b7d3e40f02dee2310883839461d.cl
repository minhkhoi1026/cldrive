//{"N":1,"result_fmod":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_fmod_withoutDD1(global float* result_fmod, int N) {
  float p1;
  float p2;
  float p3;
  float p4;
  float p5;
  float p6;
  float p7;
  float p8;
  float p9;
  float p10;

  float i = 1.0;
  float j = 2.0;
  float n = (float)(N);

  for (i = 1.0; i < 10 * n; i = i + 1.0) {
    p1 = fmod(i, j);
    p2 = fmod(i, j);
    p3 = fmod(i, j);
    p4 = fmod(i, j);
    p5 = fmod(i, j);
    p6 = fmod(i, j);
    p7 = fmod(i, j);
    p8 = fmod(i, j);
    p9 = fmod(i, j);
    p10 = fmod(i, j);
  }
  *result_fmod = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10;
}