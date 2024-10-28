//{"cols":5,"d_lineBuffer":1,"d_loc":3,"d_numEdges":2,"d_vertexBuffer":0,"rows":4,"value":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeEdges(global float* d_vertexBuffer, global float* d_lineBuffer, global int* d_numEdges, global int* d_loc, int rows, int cols, float value) {
  int myCell = get_global_id(0);

  int numVertices = rows * cols;
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
        float x1 = 0.0;
        float y1 = 0.0;
        float x2 = 0.0;
        float y2 = 0.0;

        float f1 = (value - blVal) / (tlVal - blVal);
        if (f1 < 0) {
          f1 = f1 * (-1);
        }
        x1 = myCol;
        y1 = (1 - f1) * myRow + f1 * (myRow + 1);

        float f2 = (value - blVal) / (brVal - blVal);
        if (f2 < 0) {
          f2 = f2 * (-1);
        }
        x2 = (1 - f2) * myCol + f2 * (myCol + 1);
        y2 = myRow;

        int k = atomic_add(d_loc, 4);
        d_lineBuffer[hook(1, k)] = x1;
        d_lineBuffer[hook(1, k + 1)] = y1;
        d_lineBuffer[hook(1, k + 2)] = x2;
        d_lineBuffer[hook(1, k + 3)] = y2;

        atomic_inc(d_numEdges);
      }

      if ((blVal > value && brVal < value && tlVal > value && trVal > value) || (blVal < value && brVal > value && tlVal < value && trVal < value)) {
        float x1 = 0.0;
        float y1 = 0.0;
        float x2 = 0.0;
        float y2 = 0.0;

        float f1 = (value - blVal) / (brVal - blVal);
        if (f1 < 0) {
          f1 = f1 * (-1);
        }
        x1 = (1 - f1) * myCol + f1 * (myCol + 1);
        y1 = myRow;

        float f2 = (value - brVal) / (trVal - brVal);
        if (f2 < 0) {
          f2 = f2 * (-1);
        }
        x2 = myCol + 1;
        y2 = (1 - f2) * myRow + f2 * (myRow + 1);

        int k = atomic_add(d_loc, 4);
        d_lineBuffer[hook(1, k)] = x1;
        d_lineBuffer[hook(1, k + 1)] = y1;
        d_lineBuffer[hook(1, k + 2)] = x2;
        d_lineBuffer[hook(1, k + 3)] = y2;

        atomic_inc(d_numEdges);
      }

      if ((blVal > value && brVal > value && tlVal < value && trVal > value) || (blVal < value && brVal < value && tlVal > value && trVal < value)) {
        float x1 = 0.0;
        float y1 = 0.0;
        float x2 = 0.0;
        float y2 = 0.0;

        float f1 = (value - blVal) / (tlVal - blVal);
        if (f1 < 0) {
          f1 = f1 * (-1);
        }
        x1 = myCol;
        y1 = (1 - f1) * myRow + f1 * (myRow + 1);

        float f2 = (value - tlVal) / (trVal - tlVal);
        if (f2 < 0) {
          f2 = f2 * (-1);
        }
        x2 = (1 - f2) * myCol + f2 * (myCol + 1);
        y2 = myRow + 1;

        int k = atomic_add(d_loc, 4);
        d_lineBuffer[hook(1, k)] = x1;
        d_lineBuffer[hook(1, k + 1)] = y1;
        d_lineBuffer[hook(1, k + 2)] = x2;
        d_lineBuffer[hook(1, k + 3)] = y2;

        atomic_inc(d_numEdges);
      }

      if ((blVal > value && brVal > value && tlVal > value && trVal < value) || (blVal < value && brVal < value && tlVal < value && trVal > value)) {
        float x1 = 0.0;
        float y1 = 0.0;
        float x2 = 0.0;
        float y2 = 0.0;

        float f1 = (value - tlVal) / (trVal - tlVal);
        if (f1 < 0) {
          f1 = f1 * (-1);
        }
        x1 = (1 - f1) * myCol + f1 * (myCol + 1);
        y1 = myRow + 1;

        float f2 = (value - brVal) / (trVal - brVal);
        if (f2 < 0) {
          f2 = f2 * (-1);
        }
        x2 = myCol + 1;
        y2 = (1 - f2) * myRow + f2 * (myRow + 1);

        int k = atomic_add(d_loc, 4);
        d_lineBuffer[hook(1, k)] = x1;
        d_lineBuffer[hook(1, k + 1)] = y1;
        d_lineBuffer[hook(1, k + 2)] = x2;
        d_lineBuffer[hook(1, k + 3)] = y2;

        atomic_inc(d_numEdges);
      }

      if ((blVal > value && brVal > value && tlVal < value && trVal < value) || (blVal < value && brVal < value && tlVal > value && trVal > value)) {
        float x1 = 0.0;
        float y1 = 0.0;
        float x2 = 0.0;
        float y2 = 0.0;

        float f1 = (value - blVal) / (tlVal - blVal);
        if (f1 < 0) {
          f1 = f1 * (-1);
        }
        x1 = myCol;
        y1 = (1 - f1) * myRow + f1 * (myRow + 1);

        float f2 = (value - brVal) / (trVal - brVal);
        if (f2 < 0) {
          f2 = f2 * (-1);
        }
        x2 = myCol + 1;
        y2 = (1 - f2) * myRow + f2 * (myRow + 1);

        int k = atomic_add(d_loc, 4);
        d_lineBuffer[hook(1, k)] = x1;
        d_lineBuffer[hook(1, k + 1)] = y1;
        d_lineBuffer[hook(1, k + 2)] = x2;
        d_lineBuffer[hook(1, k + 3)] = y2;

        atomic_inc(d_numEdges);
      }

      if ((blVal < value && brVal > value && tlVal < value && trVal > value) || (blVal > value && brVal < value && tlVal > value && trVal < value)) {
        float x1 = 0.0;
        float y1 = 0.0;
        float x2 = 0.0;
        float y2 = 0.0;

        float f1 = (value - blVal) / (brVal - blVal);
        if (f1 < 0) {
          f1 = f1 * (-1);
        }
        x1 = (1 - f1) * myCol + f1 * (myCol + 1);
        y1 = myRow;

        float f2 = (value - tlVal) / (trVal - tlVal);
        if (f2 < 0) {
          f2 = f2 * (-1);
        }
        x2 = (1 - f2) * myCol + f2 * (myCol + 1);
        y2 = myRow + 1;

        int k = atomic_add(d_loc, 4);
        d_lineBuffer[hook(1, k)] = x1;
        d_lineBuffer[hook(1, k + 1)] = y1;
        d_lineBuffer[hook(1, k + 2)] = x2;
        d_lineBuffer[hook(1, k + 3)] = y2;

        atomic_inc(d_numEdges);
      }

      if ((blVal > value && brVal < value && tlVal < value && trVal > value) || (blVal < value && brVal > value && tlVal > value && trVal < value)) {
        float x1 = 0.0;
        float y1 = 0.0;
        float x2 = 0.0;
        float y2 = 0.0;

        float f1 = (value - blVal) / (tlVal - blVal);
        if (f1 < 0) {
          f1 = f1 * (-1);
        }
        x1 = myCol;
        y1 = (1 - f1) * myRow + f1 * (myRow + 1);

        float f2 = (value - blVal) / (brVal - blVal);
        if (f2 < 0) {
          f2 = f2 * (-1);
        }
        x2 = (1 - f2) * myCol + f2 * (myCol + 1);
        y2 = myRow;

        int k = atomic_add(d_loc, 4);
        d_lineBuffer[hook(1, k)] = x1;
        d_lineBuffer[hook(1, k + 1)] = y1;
        d_lineBuffer[hook(1, k + 2)] = x2;
        d_lineBuffer[hook(1, k + 3)] = y2;

        x1 = 0.0;
        y1 = 0.0;
        x2 = 0.0;
        y2 = 0.0;

        f1 = (value - tlVal) / (trVal - tlVal);
        if (f1 < 0) {
          f1 = f1 * (-1);
        }
        x1 = (1 - f1) * myCol + f1 * (myCol + 1);
        y1 = myRow + 1;

        f2 = (value - brVal) / (trVal - brVal);
        if (f2 < 0) {
          f2 = f2 * (-1);
        }
        x2 = myCol + 1;
        y2 = (1 - f2) * myRow + f2 * (myRow + 1);

        k = atomic_add(d_loc, 4);
        d_lineBuffer[hook(1, k)] = x1;
        d_lineBuffer[hook(1, k + 1)] = y1;
        d_lineBuffer[hook(1, k + 2)] = x2;
        d_lineBuffer[hook(1, k + 3)] = y2;

        atomic_inc(d_numEdges);

        atomic_inc(d_numEdges);
      }
    }
  }
}