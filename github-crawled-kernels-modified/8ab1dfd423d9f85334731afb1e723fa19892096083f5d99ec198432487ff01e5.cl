//{"output":1,"scratch":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct __attribute__((packed)) S {
  char a;
  int b __attribute__((packed));
  char c;
};

kernel void uninitialized_packed_struct_memcpy(local int* scratch, global struct S* output) {
  struct S s = {1, *scratch, 2};
  *output = s;
}