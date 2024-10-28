//{"destMemory":0,"oldValues":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_atomic_cmpxchg(volatile global float* destMemory, global float* oldValues) {
  int tid = get_global_id(0);

  int oldValue, origValue, newValue;
  do {
    origValue = destMemory[hook(0, 0)];
    newValue = origValue + tid + 2;
    oldValue = atom_cmpxchg(&destMemory[hook(0, 0)], origValue, newValue);
  } while (oldValue != origValue);
  oldValues[hook(1, tid)] = oldValue;
}