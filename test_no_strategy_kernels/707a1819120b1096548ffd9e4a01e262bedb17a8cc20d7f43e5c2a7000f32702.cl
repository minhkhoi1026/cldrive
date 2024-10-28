//{"blockWidth":5,"dct8x8":2,"input":1,"inter":3,"inverse":6,"output":0,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TestDynCheckSpeed(global int* output, global int* input, global float* dct8x8, local float* inter, const unsigned int width, const unsigned int blockWidth, const unsigned int inverse) {
  unsigned int globalIdx = get_global_id(0);

  output[hook(0, globalIdx * 2)] = ((globalIdx << 3) + 1) & 15;
}