//{"dest":0,"length":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct ResLine {
  long v0;
  long v1;
  long v2;
  long v3;
  long v4;
  long v5;
};

kernel void copy_test(global int* dest, global int* src, unsigned length) {
  int i = get_global_id(0);

  if (i < length) {
    dest[hook(0, i)] = src[hook(1, i)];
  }
}