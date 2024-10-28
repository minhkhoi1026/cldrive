//{"non":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int GlobalIndex(unsigned int x, unsigned int y, unsigned int z, unsigned int w, unsigned int h, unsigned int d) {
  return (z * (w * h)) + (y * w) + x;
}

kernel void Nothing(global int* non) {
}