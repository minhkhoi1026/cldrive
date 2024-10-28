//{"inputChar":0,"inputDouble":9,"inputFloat":8,"inputInt":4,"inputLong":6,"inputShort":2,"inputUChar":1,"inputUInt":5,"inputULong":7,"inputUShort":3,"output":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelVectorTwo(char2 inputChar, uchar2 inputUChar, short2 inputShort, ushort2 inputUShort, int2 inputInt, uint2 inputUInt, long2 inputLong, ulong2 inputULong, float2 inputFloat, double2 inputDouble, global float2* output) {
  output[hook(10, 0)] = convert_float2(inputChar);
  output[hook(10, 1)] = convert_float2(inputUChar);
  output[hook(10, 2)] = convert_float2(inputShort);
  output[hook(10, 3)] = convert_float2(inputUShort);
  output[hook(10, 4)] = convert_float2(inputInt);
  output[hook(10, 5)] = convert_float2(inputUInt);
  output[hook(10, 6)] = convert_float2(inputLong);
  output[hook(10, 7)] = convert_float2(inputULong);
  output[hook(10, 8)] = convert_float2(inputFloat);
  output[hook(10, 9)] = convert_float2(inputDouble);
}