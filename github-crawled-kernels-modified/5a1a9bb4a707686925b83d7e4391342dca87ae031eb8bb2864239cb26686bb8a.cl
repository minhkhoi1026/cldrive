//{"data_in":0,"data_out":1,"height":3,"norm_factor":5,"opitch":4,"tile":7,"tile[get_local_id(0)]":8,"tile[get_local_id(1)]":6,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelTranspose(global float2* data_in, global float* data_out, int width, int height, int opitch, float norm_factor) {
  constant int TRANSPOSE_TILE_SIZE = 16;

  local float tile[16][16 + 1];
  int xIndex = get_global_id(0), yIndex = get_global_id(1), xIndexO = get_local_size(1) * get_group_id(1) + get_local_id(0), yIndexO = get_local_size(0) * get_group_id(0) + get_local_id(1), gridHeight = get_global_size(1);
  int rep = (height + gridHeight - 1) / gridHeight;
  for (int i = 0; i < rep; i++) {
    int shift = gridHeight * i;
    if (xIndex < width && yIndex + shift < height) {
      float2 v = data_in[hook(0, width * (yIndex + shift) + xIndex)];
      tile[hook(7, get_local_id(1))][hook(6, get_local_id(0))] = sqrt(v.x * v.x + v.y * v.y) * norm_factor;
    }
    barrier(0x01);
    if (xIndexO + shift < height && yIndexO < width)
      data_out[hook(1, opitch * yIndexO + xIndexO + shift)] = tile[hook(7, get_local_id(0))][hook(8, get_local_id(1))];
    barrier(0x01);
  }
}