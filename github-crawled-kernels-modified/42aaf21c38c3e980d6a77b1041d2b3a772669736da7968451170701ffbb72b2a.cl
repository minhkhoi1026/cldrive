//{"N":1,"result_nextafter":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_nextafter_withDD1(global float* result_nextafter, int N) {
  float t1 = 1.4;
  float t2 = -3.0;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    t1 = nextafter(t1, t2);
    ;
  }
  *result_nextafter = t1;
}