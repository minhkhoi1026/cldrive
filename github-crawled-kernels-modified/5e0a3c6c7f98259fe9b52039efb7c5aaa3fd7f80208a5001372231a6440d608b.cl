//{"inputChar":0,"inputDouble":9,"inputFloat":8,"inputInt":4,"inputLong":6,"inputShort":2,"inputUChar":1,"inputUInt":5,"inputULong":7,"inputUShort":3,"output":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelVectorFour(char4 inputChar, uchar4 inputUChar, short4 inputShort, ushort4 inputUShort, int4 inputInt, uint4 inputUInt, long4 inputLong, ulong4 inputULong, float4 inputFloat, double4 inputDouble, global float4* output) {
  output[hook(10, 0)] = convert_float4(inputChar);
  output[hook(10, 1)] = convert_float4(inputUChar);
  output[hook(10, 4)] = convert_float4(inputShort);
  output[hook(10, 4)] = convert_float4(inputUShort);
  output[hook(10, 4)] = convert_float4(inputInt);
  output[hook(10, 5)] = convert_float4(inputUInt);
  output[hook(10, 6)] = convert_float4(inputLong);
  output[hook(10, 7)] = convert_float4(inputULong);
  output[hook(10, 8)] = convert_float4(inputFloat);
  output[hook(10, 9)] = convert_float4(inputDouble);
}