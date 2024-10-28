//{"maybePrime":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_prime(const int maybePrime, global bool* out) {
  float tmp = maybePrime;
  tmp = sqrt(tmp);
  int root = ceil(tmp);
  for (int i = 2; i <= root; i++) {
    if (maybePrime % i == 0) {
      *out = false;
      return;
    }
  }
  *out = true;
}