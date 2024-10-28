//{"block":4,"height":3,"idata":1,"odata":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mtLocal(global float* odata, global float* idata, int width, int height, local float* block) {
  unsigned int localHeight = get_local_size(1);
  unsigned int localWidth = get_local_size(0);

  unsigned int groupRow = get_group_id(1);
  unsigned int groupColumn = get_group_id(0);

  unsigned int row = get_global_id(1);
  unsigned int column = get_global_id(0);

  unsigned int localRow = get_local_id(1);
  unsigned int localColumn = get_local_id(0);

  unsigned int index_in = row * width + column;
  block[hook(4, localRow * (localWidth) + localColumn)] = idata[hook(1, index_in)];

  barrier(0x01);

  unsigned int Z = localWidth * groupColumn * height + localHeight * groupRow;

  unsigned int localIndex = localRow * localWidth + localColumn;
  unsigned int tRow = localIndex / localHeight;
  unsigned int tColumn = localIndex % localHeight;

  unsigned int index_out = Z + height * tRow + tColumn;
  odata[hook(0, index_out)] = block[hook(4, tColumn * localWidth + tRow)];
}