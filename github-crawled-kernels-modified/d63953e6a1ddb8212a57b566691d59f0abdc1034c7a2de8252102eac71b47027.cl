//{"data":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void my_kernel(global char* data, const int size) {
  int2 lid = {get_local_id(0), get_local_id(1)};
  int2 pos = {get_global_id(0), get_global_id(1)};

  data[hook(0, pos.y * get_global_size(0) + pos.x)] = (lid.y << 4) + lid.x;
}