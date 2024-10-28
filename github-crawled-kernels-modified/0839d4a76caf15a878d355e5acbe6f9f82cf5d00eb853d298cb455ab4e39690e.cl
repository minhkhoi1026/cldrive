//{"N":2,"delta":1,"predicted":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void updatePredicted(global float4* predicted, const global float4* delta, const unsigned int N) {
  const unsigned int i = get_global_id(0);
  if (i >= N)
    return;

  predicted[hook(0, i)].xyz = predicted[hook(0, i)].xyz + delta[hook(1, i)].xyz;
}