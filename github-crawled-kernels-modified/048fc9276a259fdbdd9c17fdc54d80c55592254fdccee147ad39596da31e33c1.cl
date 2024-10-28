//{"in":0,"matrix":3,"out":1,"sizeOfDim":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int numOfNeighbor(global const int* matrix, int posx, int posy, int sizeOfDim) {
  int num = 0;
  if (posy > 0) {
    if (matrix[hook(3, (posy - 1) * sizeOfDim + posx)])
      num++;
    if (posx > 0 && matrix[hook(3, (posy - 1) * sizeOfDim + (posx - 1))])
      num++;
    if (posx + 1 < sizeOfDim && matrix[hook(3, (posy - 1) * sizeOfDim + (posx + 1))])
      num++;
  }
  if (posy + 1 < sizeOfDim) {
    if (matrix[hook(3, (posy + 1) * sizeOfDim + posx)])
      num++;
    if (posx > 0 && matrix[hook(3, (posy + 1) * sizeOfDim + (posx - 1))])
      num++;
    if (posx + 1 < sizeOfDim && matrix[hook(3, (posy + 1) * sizeOfDim + (posx + 1))])
      num++;
  }
  if (posx > 0 && matrix[hook(3, (posy) * sizeOfDim + (posx - 1))])
    num++;
  if (posx + 1 < sizeOfDim && matrix[hook(3, (posy) * sizeOfDim + (posx + 1))])
    num++;

  return num;
}

kernel void next(global const int* in, global int* restrict out, int sizeOfDim) {
  int index = get_global_id(0);
  int posx = index % sizeOfDim;
  int posy = index / sizeOfDim;

  int num = numOfNeighbor(in, posx, posy, sizeOfDim);

  out[hook(1, index)] = (num == 3) || (num == 2 && in[hook(0, index)]);
}