//{"a":1,"global_p":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_pointers(volatile global void* global_p, global const int4* a) {
  int i;
  unsigned int ui;

  prefetch(a, 2);

  atom_add((volatile global int*)global_p, i);
  atom_add((volatile global int*)global_p, i);
  atom_cmpxchg((volatile global unsigned int*)global_p, ui, ui);
}