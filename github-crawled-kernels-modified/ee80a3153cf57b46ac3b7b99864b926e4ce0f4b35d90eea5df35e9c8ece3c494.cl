//{"a":3,"n":2,"swapBuffer":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

kernel void linearactivatearray(global float* x, global float* swapBuffer, int n, ACTIVATION a) {
  int stepSize = get_local_size(0);
  int index = get_global_id(0) * stepSize;
  int count = 0;

  float8 xLocal = (float8)0;
  vstore8(xLocal, 0, &swapBuffer[hook(1, index)]);
}