//{"buckets":1,"empty":2,"tab":0}
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

kernel void init_buckets(global Bucket* tab, const unsigned int buckets, const unsigned int empty) {
  for (ulong i = 0; i < buckets; ++i) {
    tab[hook(0, i)].key = empty;
    tab[hook(0, i)].val = empty;
  }
}