//{"N":1,"result_nextafter":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_nextafter_withoutDD1(global float* result_nextafter, int N) {
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
  float j = 2;
  float n = 7 * (float)(N);

  for (i = 0.0; i < n; i = i + 1.0) {
    t1 = nextafter(i, j);
    t2 = nextafter(i, j);
    t3 = nextafter(i, j);
    t4 = nextafter(i, j);
    t5 = nextafter(i, j);
    t6 = nextafter(i, j);
    t7 = nextafter(i, j);
    t8 = nextafter(i, j);
    t9 = nextafter(i, j);
    t10 = nextafter(i, j);
  }
  *result_nextafter = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}