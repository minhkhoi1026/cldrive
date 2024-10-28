//{"cols":3,"d_returnValue":1,"d_vertexBuffer":0,"rows":2,"value":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void countEdges(global float* d_vertexBuffer, global int* d_returnValue, int rows, int cols, float value) {
  int myCell = get_global_id(0);
  int numCells = (rows - 1) * (cols - 1);

  size_t gridSize = get_global_size(0);

  for (int i = myCell; i < numCells; i += gridSize) {
    int myCol = i % (cols - 1);
    int myRow = (int)(i / (cols - 1));

    float blVal = d_vertexBuffer[hook(0, myRow * cols + myCol)];
    float brVal = d_vertexBuffer[hook(0, myRow * cols + myCol + 1)];
    float tlVal = d_vertexBuffer[hook(0, (myRow + 1) * cols + myCol)];
    float trVal = d_vertexBuffer[hook(0, (myRow + 1) * cols + myCol + 1)];

    if (blVal != -9999 && brVal != -9999 && tlVal != -9999 && trVal != -9999) {
      if ((blVal < value && brVal > value && tlVal > value && trVal > value) || (blVal > value && brVal < value && tlVal < value && trVal < value)) {
        atomic_inc(d_returnValue);
      }

      if ((blVal > value && brVal < value && tlVal > value && trVal > value) || (blVal < value && brVal > value && tlVal < value && trVal < value)) {
        atomic_inc(d_returnValue);
      }

      if ((blVal > value && brVal > value && tlVal < value && trVal > value) || (blVal < value && brVal < value && tlVal > value && trVal < value)) {
        atomic_inc(d_returnValue);
      }

      if ((blVal > value && brVal > value && tlVal > value && trVal < value) || (blVal < value && brVal < value && tlVal < value && trVal > value)) {
        atomic_inc(d_returnValue);
      }

      if ((blVal < value && brVal > value && tlVal < value && trVal > value) || (blVal > value && brVal < value && tlVal > value && trVal < value)) {
        atomic_inc(d_returnValue);
      }

      if ((blVal > value && brVal > value && tlVal < value && trVal < value) || (blVal < value && brVal < value && tlVal > value && trVal > value)) {
        atomic_inc(d_returnValue);
      }

      if ((blVal > value && brVal < value && tlVal < value && trVal > value) || (blVal < value && brVal > value && tlVal > value && trVal < value)) {
        atomic_add(d_returnValue, 2);
      }
    }
  }
}