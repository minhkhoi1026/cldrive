//{"N":1,"result_copysign":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_copysign_withDD1(global float* result_copysign, int N) {
  float p1 = 1.2;
  float p2 = -3.4;
  float p3 = 0.0;
  int i = 0;
  for (i = 0; i < N; i++) {
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    p3 += copysign(p1, p2);
    p2 += copysign(p2, p1);
    p1 += copysign(p2, p3);
    ;
  }
  *result_copysign = p1 + p2 + p3;
}