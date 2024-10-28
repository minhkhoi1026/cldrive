//{"A":0,"c":1,"i":2,"kFirst":3,"kSecond":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float kFirst[3] = {1.0f, 2.0f, 3.0f};
constant float kSecond[3] = {10.0f, 11.0f, 12.0f};

kernel void foo(global float* A, int c, int i) {
  *A = c == 0 ? kFirst[hook(3, i)] : kSecond[hook(4, i)];
}