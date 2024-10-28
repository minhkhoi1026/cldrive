//{"buffer_size":10,"gradient":0,"gradientRecord":4,"gradientRecord_internal_size2":5,"gradient_internal_size2":3,"gradient_size1":1,"gradient_size2":2,"lastRelevantIndex":9,"nextRecordIndex":8,"recordStart":7,"rewardRecord":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_gradients(global float* gradient, unsigned int gradient_size1, unsigned int gradient_size2, unsigned int gradient_internal_size2, global const float* gradientRecord, unsigned int gradientRecord_internal_size2, global const float* rewardRecord, global const int* recordStart, global const int* nextRecordIndex, global const int* lastRelevantIndex, unsigned int buffer_size) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < gradient_size1; row += get_num_groups(0)) {
    for (unsigned int col = col_gid; col < gradient_size2; col += get_local_size(0)) {
      for (int i = *recordStart; i != (*lastRelevantIndex + 1) % buffer_size; i++, i %= buffer_size) {
        gradient[hook(0, row * gradient_internal_size2 + col)] += gradientRecord[hook(4, (row + i * gradient_size1) * gradientRecord_internal_size2 + col)] * rewardRecord[hook(6, i)];
      }
    }
  }
}