//{"block":5,"height":4,"idata":1,"odata":0,"offset":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void shared_copy(global float* odata, global float* idata, int offset, int width, int height, local float* block) {
  unsigned int xIndex = get_global_id(0);
  unsigned int yIndex = get_global_id(1);

  unsigned int index_in = yIndex * width + xIndex + offset;
  if ((xIndex + offset < width) && (yIndex < height)) {
    block[hook(5, get_local_id(1) * (16 + 1) + get_local_id(0))] = idata[hook(1, index_in)];
  }

  barrier(0x01);

  if ((xIndex < height) && (yIndex + offset < width)) {
    odata[hook(0, index_in)] = block[hook(5, get_local_id(1) * (16 + 1) + get_local_id(0))];
  }
}