//{"N":0,"batch":4,"layers":3,"out":5,"spatial":2,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

kernel void flattenarray(int N, global float* x, int spatial, int layers, int batch, global float* out) {
  int stepSize = get_local_size(0);
  int idx = get_global_id(0) * stepSize;
  int count = 0, i, in_s, in_c, i2, i1;

  for (; count < 8; count++) {
    i = idx;
    in_s = i % spatial;
    i = i / spatial;
    in_c = i % layers;
    i = i / layers;

    i1 = in_c * spatial + in_s;
    i2 = in_s * layers + in_c;

    out[hook(5, i2)] = x[hook(1, i1)];
    idx = idx + 1;
  }
}