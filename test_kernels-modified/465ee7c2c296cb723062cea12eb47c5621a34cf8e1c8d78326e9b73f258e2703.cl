//{"empty":2,"out":0,"out_count":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct Bucket {
  unsigned int key;
  unsigned int val;
};
typedef struct Bucket Bucket;

kernel void init(global unsigned int* out, const ulong out_count, const unsigned int empty) {
  for (unsigned int i = 0; i < out_count; ++i) {
    out[hook(0, i)] = empty;
  }
}