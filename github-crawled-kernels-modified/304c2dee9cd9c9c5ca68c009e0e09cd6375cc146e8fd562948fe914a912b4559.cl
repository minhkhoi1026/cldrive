//{"bitX":3,"bitY":4,"data":0,"type":5,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swapkernel(global double* data, const int x, const int y, global int* bitX, global int* bitY, const unsigned int type) {
  int idX = get_global_id(0);
  int idY = get_global_id(1);
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
      BASE = idY * x;
      if (idX < bitX[hook(3, idX)]) {
        OLD = 2 * (BASE + STRIDE * idX);
        NEW = 2 * (BASE + STRIDE * bitX[hook(3, idX)]);

        holder = data[hook(0, NEW)];
        data[hook(0, NEW)] = data[hook(0, OLD)];
        data[hook(0, OLD)] = holder;

        holder = data[hook(0, NEW + 1)];
        data[hook(0, NEW + 1)] = data[hook(0, OLD + 1)];
        data[hook(0, OLD + 1)] = holder;
      }
      break;
    case 2:
      BASE = idX;
      STRIDE = x;
      if (idY < bitY[hook(4, idY)]) {
        OLD = 2 * (BASE + STRIDE * idY);
        NEW = 2 * (BASE + STRIDE * bitY[hook(4, idY)]);

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