//{"s_key":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void generate_input_simple(local unsigned int* s_key) {
  int local_id = get_local_id(0);
  int offset_local_id_descending = 2 * get_local_size(0) - 1 - local_id;

  s_key[hook(0, local_id)] = local_id * 2 + 1;
  s_key[hook(0, offset_local_id_descending)] = local_id * 2;
}

inline void coex(local unsigned int* keyA, local unsigned int* keyB, const int dir) {
  unsigned int t;

  if ((*keyA > *keyB) == dir) {
    t = *keyA;
    *keyA = *keyB;
    *keyB = t;
  }
}

inline void bitonic_simple(local unsigned int* s_key, int size) {
  int local_id = get_local_id(0);
  int pos;

  for (unsigned int stride = size >> 1; stride > 0; stride >>= 1) {
    barrier(0x01);
    pos = 2 * local_id - (local_id & (stride - 1));
    coex(&s_key[hook(0, pos)], &s_key[hook(0, pos + stride)], 1);
  }
}

kernel void warmup(local unsigned int* s_key) {
  generate_input_simple(s_key);
  barrier(0x01);

  bitonic_simple(s_key, get_local_size(0) * 2);
}