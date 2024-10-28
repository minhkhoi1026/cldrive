//{"A":0,"At":1,"height":2,"lds":4,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_transpose(global const float* A, global float* At, const int height, const int width) {
  local float lds[272];

  size_t xIndex = get_group_id(0) * 16 + get_local_id(0);
  size_t yIndex = get_group_id(1) * 16 + get_local_id(1);
  size_t lidx = get_local_id(0);
  size_t lidy = get_local_id(1);

  if ((xIndex < width) && (yIndex < height)) {
    size_t index_in = yIndex * width + xIndex;
    lds[hook(4, lidy * (16 + 1) + lidx)] = A[hook(0, index_in)];
  }

  barrier(0x01);

  xIndex = get_group_id(1) * 16 + get_local_id(0);
  yIndex = get_group_id(0) * 16 + get_local_id(1);

  if ((xIndex < height) && (yIndex < width)) {
    size_t index_out = yIndex * height + xIndex;
    At[hook(1, index_out)] = lds[hook(4, lidx * (16 + 1) + lidy)];
  }
}