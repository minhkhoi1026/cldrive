//{"BSx":6,"BSy":7,"alpha_s":2,"fore_th":3,"gradx":4,"grady":5,"is_deeper_magic":1,"mapRes":8,"total":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TestMagic(const int total, const int is_deeper_magic, const float alpha_s, const float fore_th, global const float* gradx, global const float* grady, global float* BSx, global float* BSy, global int* mapRes) {
 private
  const size_t i = get_global_id(0);
 private
  const size_t gpu_used = get_global_size(0);

 private
  const size_t elements_count = total / (gpu_used * 16);
 private
  const size_t offset = i * total / gpu_used;

  for (size_t k = 0; k < elements_count; ++k) {
    int16 mr = vload16(k, mapRes + offset);
    const int16 twos = 2;
    mr += twos;
    vstore16(mr, k, mapRes + offset);
  }
}