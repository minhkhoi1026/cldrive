//{"in1":0,"in2":2,"in3":4,"out1":1,"out2":3,"out3":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_vector_3(global int3* in1, global int3* out1, global short3* in2, global int3* out2, global char3* in3, global int3* out3) {
  size_t id = get_global_id(0);

  out1[hook(1, id)] = in1[hook(0, id)] + (int)id;

  out2[hook(3, id)] = convert_int3(in2[hook(2, id)]) + (int)id;
  out3[hook(5, id)] = convert_int3(in3[hook(4, id)]) + (int)id;
}