//{"_buf0":4,"count":0,"offset":1,"output":2,"output_offset":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void extra_serial_reduce(unsigned int count, unsigned int offset, global float* output, unsigned int output_offset, global float4* _buf0) {
  float result = length(_buf0[hook(4, offset)]);
  for (unsigned int i = offset + 1; i < count; i++)
    result = ((result) * (length(_buf0[hook(4, i)])));
  output[hook(2, output_offset)] = result;
}