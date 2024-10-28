//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef long unsigned int size_t;
size_t __attribute__((overloadable)) __attribute__((const)) get_global_id(unsigned int dimindx);
kernel void mem_clobber(global int* x) {
  x[hook(0, 0)] = 1;
  __asm__("" ::: "cc", "memory");
  x[hook(0, 0)] += 1;
}