//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((noinline)) void non_convfun(void) {
  volatile int* p;
  *p = 0;
}

void convfun(void) __attribute__((convergent));
void nodupfun(void) __attribute__((noduplicate));

void f(void);
void g(void);
void test_merge_if(int a) {
  if (a) {
    f();
  }
  non_convfun();
  if (a) {
    g();
  }
}
void test_no_merge_if(int a) {
  if (a) {
    f();
  }
  convfun();
  if (a) {
    g();
  }
}
void test_unroll() {
  for (int i = 0; i < 10; i++)
    convfun();
}
void test_not_unroll() {
  for (int i = 0; i < 10; i++)
    nodupfun();
}

kernel void assume_convergent_asm() {
  __asm__ volatile("s_barrier");
}