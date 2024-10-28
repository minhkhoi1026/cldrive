//{"a":2,"b":3,"heightA":0,"widthA":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void global_bandwidth_vec16_v2(const int heightA, const int widthA, global float16* a, global float16* b) {
  const int idx = get_global_id(0);
  const int step = idx << 4;

  float16 value = *(a + step);
  *(b + step) = value;
}