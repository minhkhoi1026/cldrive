//{"buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void callback(global float* buffer) {
  float4 five_vector = (float4)(5.0);

  for (int i = 0; i < 1024; i++) {
    vstore4(five_vector, i, buffer);
  }
}