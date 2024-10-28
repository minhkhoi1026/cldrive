//{"A":0,"B":1,"C":2,"D":3,"f":4,"g":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float* A, global float* B, global int* C, global float* D, float f, float g) {
  *A = f + g;
  *B = 0.0f;
  *C = 12;
  *D = f;
}