//{"changes":3,"deltas":0,"o":1,"weights":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bpnn_adjust_weights(global float* deltas, global float* o, global float* weights, global float* changes) {
  int ii = get_global_id(1) + 1;
  int jj = get_global_id(0) + 1;
  int index = ii * (1 + get_global_size(0)) + jj;
  float adjust = 0.3f * changes[hook(3, index)] + (1.0f - 0.3f) * 0.3f * o[hook(1, ii)] * deltas[hook(0, jj)];
  weights[hook(2, index)] += adjust;
  changes[hook(3, index)] = adjust;
}