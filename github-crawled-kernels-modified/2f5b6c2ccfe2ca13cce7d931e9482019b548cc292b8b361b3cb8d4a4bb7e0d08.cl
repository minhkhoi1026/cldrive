//{"heap":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct clheap {
  ulong size;
  unsigned int head;
  unsigned int free;
};

kernel void initializeClheap(global void* heap, ulong size) {
  struct clheap* header = heap;

  header->size = size;
  header->head = header->free = (unsigned int)(heap + sizeof(struct clheap));
}