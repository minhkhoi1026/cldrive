//{"buffer_size":2,"lastRelevantIndex":1,"recordStart":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_next_record_start(global int* recordStart, global const int* lastRelevantIndex, unsigned int buffer_size) {
  if (get_global_id(0) == 0) {
    *recordStart = (*lastRelevantIndex + 1) % buffer_size;
  }
}