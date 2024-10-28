//{"N":0,"batch":4,"filters":5,"mean":2,"spatial":6,"variance":3,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

kernel void normalizearray(int N, global float* x, global float* mean, global float* variance, int batch, int filters, int spatial) {
  int stepSize = get_local_size(0);
  int index = get_global_id(0) * stepSize;

  int f = 0, count = 0;

  for (; count < 8; count++) {
    f = (index / spatial) % filters;
    x[hook(1, index)] = (x[hook(1, index)] - mean[hook(2, f)]) / (sqrt(variance[hook(3, f)]) + .000001f);
    index = index + 1;
  }
}