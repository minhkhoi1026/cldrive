//{"buffer_size":1,"nextRecordIndex":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_next_record_index(global int* nextRecordIndex, unsigned int buffer_size) {
  if (get_global_id(0) == 0) {
    *nextRecordIndex++;
    *nextRecordIndex %= buffer_size;
  }
}