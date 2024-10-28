//{"bitX":4,"bitY":5,"bitZ":6,"data":0,"type":7,"x":1,"y":2,"z":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swapkernel(global double* data, const int x, const int y, const int z, global int* bitX, global int* bitY, global int* bitZ, const unsigned int type) {
  int idX = get_global_id(0);
  int idY = get_global_id(1);
  int idZ = get_global_id(2);
 private
  int BASE = 0;
 private
  int STRIDE = 1;
 private
  double holder;
 private
  int runner = 0;
 private
  int OLD = 0, NEW = 0;

  switch (type) {
    case 1:
      BASE = idZ * x * y + idY * x;
      if (idX < bitX[hook(4, idX)]) {
        OLD = 2 * (BASE + STRIDE * idX);
        NEW = 2 * (BASE + STRIDE * bitX[hook(4, idX)]);

        holder = data[hook(0, NEW)];
        data[hook(0, NEW)] = data[hook(0, OLD)];
        data[hook(0, OLD)] = holder;

        holder = data[hook(0, NEW + 1)];
        data[hook(0, NEW + 1)] = data[hook(0, OLD + 1)];
        data[hook(0, OLD + 1)] = holder;
      }
      break;
    case 2:
      BASE = idZ * x * y + idX;
      STRIDE = x;
      if (idY < bitY[hook(5, idY)]) {
        OLD = 2 * (BASE + STRIDE * idY);
        NEW = 2 * (BASE + STRIDE * bitY[hook(5, idY)]);

        holder = data[hook(0, NEW)];
        data[hook(0, NEW)] = data[hook(0, OLD)];
        data[hook(0, OLD)] = holder;

        holder = data[hook(0, NEW + 1)];
        data[hook(0, NEW + 1)] = data[hook(0, OLD + 1)];
        data[hook(0, OLD + 1)] = holder;
      }
      break;
    case 3:
      BASE = idY * x + idX;
      STRIDE = x * y;
      if (idZ < bitZ[hook(6, idZ)]) {
        OLD = 2 * (BASE + STRIDE * idZ);
        NEW = 2 * (BASE + STRIDE * bitZ[hook(6, idZ)]);

        holder = data[hook(0, NEW)];
        data[hook(0, NEW)] = data[hook(0, OLD)];
        data[hook(0, OLD)] = holder;

        holder = data[hook(0, NEW + 1)];
        data[hook(0, NEW + 1)] = data[hook(0, OLD + 1)];
        data[hook(0, OLD + 1)] = holder;
      }
      break;
  }
}