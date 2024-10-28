//{"A":0,"i":1,"ppp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant uint3 ppp[2] = {(uint3)(1, 2, 3), (uint3)(5)};

kernel void foo(global unsigned int* A, unsigned int i) {
  *A = ppp[hook(2, i)].x;
}