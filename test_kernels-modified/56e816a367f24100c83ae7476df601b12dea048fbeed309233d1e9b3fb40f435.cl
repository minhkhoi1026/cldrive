//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef long unsigned int size_t;
size_t __attribute__((overloadable)) __attribute__((const)) get_global_id(unsigned int dimindx);
kernel void out_clobber(global int* x) {
  int i = get_global_id(0);
  __asm__("barrier");
  int a = x[hook(0, i)];
  __asm__("earlyclobber_instruction_out %0" : "=&r"(a));
  a += 1;
  x[hook(0, i)] = a;
}