//{"count":0,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_doAdd_vector_float(int count, global float* result) {
  int bulkCount = count >> 6;
  int threadID = get_local_id(0);
  for (int i = 0; i < bulkCount; i++) {
    float4 value;
    value.x = i;
    value.y = value.x + 1.0f;
    value.z = value.x + 2.0f;
    value.w = value.x + 3.0f;

    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;
    value = value + value;

    if (threadID > 1024)
      *result = value.x + value.y + value.z + value.w;
  }
}