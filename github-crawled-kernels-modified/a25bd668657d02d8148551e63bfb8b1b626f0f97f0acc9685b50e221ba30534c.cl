//{"histogram":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Scan(global unsigned int* histogram) {
  unsigned int sum = 0;
  for (size_t i = 0; i < 8; ++i) {
    unsigned int val = atomic_xchg(&histogram[hook(0, i)], sum);
    sum += val;
  }
}