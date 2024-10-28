//{"T":5,"h":4,"kls":1,"sims":0,"size":3,"weights":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_weights(global float* sims, global float* kls, global float* weights, const int size, const float h, const float T) {
  const int tx = get_global_id(0);

  if (tx < size) {
    float weight = exp(sims[hook(0, tx)] / h + kls[hook(1, tx)] / T);
    if (isnan(weight) || isinf(weight)) {
      weight = 0.0f;
    }
    weights[hook(2, tx)] = weight;
  }
}