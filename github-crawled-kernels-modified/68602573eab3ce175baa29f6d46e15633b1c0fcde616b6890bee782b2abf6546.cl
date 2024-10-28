//{"block":5,"height":4,"idata":1,"odata":0,"offset":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(global float* odata, global float* idata, int offset, int width, int height, local float* block) {
  unsigned int xIndex = get_global_id(0);
  unsigned int yIndex = get_global_id(1);

  if ((xIndex + offset < width) && (yIndex < height)) {
    unsigned int index_in = yIndex * width + xIndex + offset;
    block[hook(5, get_local_id(1) * (16 + 1) + get_local_id(0))] = idata[hook(1, index_in)];
  }

  barrier(0x01);

  xIndex = get_group_id(1) * 16 + get_local_id(0);
  yIndex = get_group_id(0) * 16 + get_local_id(1);
  if ((xIndex < height) && (yIndex + offset < width)) {
    unsigned int index_out = yIndex * height + xIndex;
    odata[hook(0, index_out)] = block[hook(5, get_local_id(0) * (16 + 1) + get_local_id(1))];
  }
}