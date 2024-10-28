//{"N":1,"result_fmod":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_fmod_withDD1(global float* result_fmod, int N) {
  float p1 = 7456.3;
  float p2 = 2.0;
  int i = 0;
  for (i = 0; i < N; i++) {
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    p1 = fmod(p1, p2);
    ;
  }
  *result_fmod = p1;
}