//{"biases":2,"filters":5,"mean":3,"output":0,"scales":1,"spatial":6,"variance":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

kernel void normscaleaddbias(global float* output, global float* scales, global float* biases, global float* mean, global float* variance, int filters, int spatial) {
  int filter = get_group_id(1);
  int stepSize = get_local_size(0);
  int offset = get_global_id(0) * stepSize;
  int count = 0, f = 0, filterOffset = 0;

  for (; count < 8; count++) {
    filterOffset = filter * spatial + offset;
    f = (filterOffset / spatial) % filters;
    output[hook(0, filterOffset)] = (output[hook(0, filterOffset)] - mean[hook(3, f)]) / (sqrt(variance[hook(4, f)]) + .000001f);
    output[hook(0, filterOffset)] = output[hook(0, filterOffset)] * scales[hook(1, filter)] + biases[hook(2, filter)];
    offset = offset + 1;
  }
}