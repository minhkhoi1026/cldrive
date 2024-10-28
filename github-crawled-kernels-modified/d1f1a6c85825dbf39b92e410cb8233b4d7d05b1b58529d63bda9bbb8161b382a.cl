//{"data":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomic_cmpxchg_false_race(global int* data, local int* scratch) {
  int l = get_local_id(0);
  if (l == 0) {
    scratch[hook(1, 0)] = 0;
  }
  barrier(0x01);

  bool done = false;
  int before, old;
  int result;
  for (int i = 0; i < get_local_size(0); i++) {
    barrier(0x01);
    before = scratch[hook(1, 0)];
    barrier(0x01);

    if (!done) {
      old = atomic_cmpxchg(scratch, before, before + 1);
      if (old == before) {
        done = true;
        result = scratch[hook(1, 0)];
      }
    }
  }

  barrier(0x01);
  if (l == 0) {
    *data = *scratch;
  }
  data[hook(0, l + 1)] = result;
}