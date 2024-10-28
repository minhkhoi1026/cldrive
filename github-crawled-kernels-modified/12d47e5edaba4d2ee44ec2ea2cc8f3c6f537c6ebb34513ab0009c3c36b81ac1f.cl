//{"cols":2,"data":6,"data_in":0,"data_out":1,"l1":4,"tile":5,"window_count":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float safe_read(global float* data, int frame, int col, int pitch, int window_count) {
  return (frame < window_count) ? data[hook(6, pitch * frame + col)] : 0;
}

kernel void kernelDelta(global float* data_in, global float* data_out, int cols, int window_count, int l1, local float* tile) {
  int frame_index = get_global_id(1), col = get_global_id(0), idx_shift = get_global_size(1);
  constant int DELTA_TILE_SIZE = 16;
  while (true) {
    barrier(0x01);
    tile[hook(5, DELTA_TILE_SIZE * get_local_id(1) + get_local_id(0))] = safe_read(data_in, frame_index, col, cols, window_count + 2 * l1);
    if (get_local_id(1) < 2 * l1)
      tile[hook(5, DELTA_TILE_SIZE * (DELTA_TILE_SIZE + get_local_id(1)) + get_local_id(0))] = safe_read(data_in, frame_index + DELTA_TILE_SIZE, col, cols, window_count + 2 * l1);
    barrier(0x01);

    if (frame_index >= window_count)
      return;

    float num = 0, den = 0;
    for (int l = 1; l <= l1; l++) {
      num += l * (tile[hook(5, DELTA_TILE_SIZE * (get_local_id(1) + l1 + l) + get_local_id(0))] - tile[hook(5, DELTA_TILE_SIZE * (get_local_id(1) + l1 - l) + get_local_id(0))]);
      den += l * l;
    }
    data_out[hook(1, cols * frame_index + col)] = num / (2 * den);

    frame_index += idx_shift;
  }
}