//{"output":1,"scratch":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct S {
  char a;
  int b;
  char c;
};

kernel void padded_struct_memcpy_fp(local struct S* scratch, global struct S* output) {
  int lid = get_local_id(0);

  struct S s;
  s.a = 42;
  s.b = 0xF9FFFFF9;
  s.c = 127;

  if (lid == 0) {
    *scratch = s;
  }
  barrier(0x01);
  if (lid == 1) {
    *output = *scratch;
  }
}