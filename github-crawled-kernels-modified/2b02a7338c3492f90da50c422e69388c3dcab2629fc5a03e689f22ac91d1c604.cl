//{"N":1,"result_sinh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sinh_withDD4(global float* result_sinh, int N) {
  float t1 = 0.0;
  float4 t2 = t1 + (float4)(0);
  int i = 0;
  for (i = 0; i < N; i++) {
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    t2 = sinh(t2);
    ;
  }
  *result_sinh = t2.s0 + t2.s1 + t2.s2 + t2.s3;
}