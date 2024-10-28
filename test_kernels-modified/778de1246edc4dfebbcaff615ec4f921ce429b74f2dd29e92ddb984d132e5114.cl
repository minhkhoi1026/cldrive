//{"buffer":0,"nbh":3,"nsbh":2,"nsbw":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zero_out_bottom(global short* buffer, unsigned int nsbw, unsigned int nsbh, unsigned int nbh) {
  size_t gx = get_global_id(0);
  size_t super_block_y = nsbh - 1;
  if ((super_block_y << 0x1) + 1 >= nbh) {
    size_t super_block_x = gx >> 0x7;
    size_t super_block_id = (super_block_y * nsbw) + super_block_x;
    size_t local_block_id = (gx & 0x7F) > 0x3F ? 3 : 2;
    size_t field_id = (gx & 0x3F);
    size_t block_id = ((super_block_id << 0x8) | (local_block_id << 0x6) | field_id);

    buffer[hook(0, block_id)] = 0;
  }
}