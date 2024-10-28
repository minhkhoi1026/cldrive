//{"hist":1,"local_hist":3,"source":0,"src_step":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram_1C(global const uchar* source, global unsigned int* hist, unsigned int src_step) {
  const int gx = get_global_id(0);
  const int gy = get_global_id(1);
  const int2 pos = {gx, gy};

  src_step /= sizeof(uchar);

  if (get_local_size(0) * get_local_size(1) < 256)
    return;

  local unsigned int local_hist[256];

  int local_index = get_local_id(0) + get_local_id(1) * get_local_size(0);

  if (local_index < 256)
    local_hist[hook(3, local_index)] = 0;

  barrier(0x01);

  uchar value = source[hook(0, gy * src_step + gx)];

  if (value < 256)
    atom_inc(&local_hist[hook(3, value)]);

  barrier(0x01);

  if (local_index < 256)
    atom_add(&hist[hook(1, local_index)], local_hist[hook(3, local_index)]);
}