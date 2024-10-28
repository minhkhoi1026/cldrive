//{"sequence":1,"table":0,"valid":2,"winners":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int MurmurHash(const unsigned int value, const unsigned int seed) {
  const unsigned int c1 = 0xcc9e2d51;
  const unsigned int c2 = 0x1b873593;
  const unsigned int r1 = 15;
  const unsigned int r2 = 13;
  const unsigned int m = 5;
  const unsigned int n = 0xe6546b64;

  unsigned int hash = value;
  hash *= c1;
  hash = (hash << r1) | (hash >> (32 - r1));
  hash *= c2;

  hash ^= value;
  hash = ((hash << r2) | (hash >> (32 - r2))) * m + n;

  hash ^= (hash >> 16);
  hash *= 0x85ebca6b;
  hash ^= (hash >> 13);
  hash *= 0xc2b2ae35;
  hash ^= (hash >> 16);

  return hash;
}

unsigned int DuplicateHash(const unsigned int value, const unsigned int xor, const unsigned int prime) {
  unsigned int hash = MurmurHash(value, xor);
  return hash % prime;
}

kernel void ExtractWinners(global int* table, global int* sequence, global int* valid, global int* winners) {
  const int id = get_global_id(0);
  const int index = table[hook(0, id)];
  if (index != -1) {
    valid[hook(2, id)] = 1;
    winners[hook(3, id)] = sequence[hook(1, index)];
  } else {
    valid[hook(2, id)] = 0;
    winners[hook(3, id)] = -1;
  }
}