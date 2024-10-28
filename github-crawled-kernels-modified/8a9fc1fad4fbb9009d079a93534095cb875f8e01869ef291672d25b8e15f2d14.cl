//{"inputChar":0,"inputDouble":9,"inputFloat":8,"inputInt":4,"inputLong":6,"inputShort":2,"inputUChar":1,"inputUInt":5,"inputULong":7,"inputUShort":3,"output":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelVectorThree(char3 inputChar, uchar3 inputUChar, short3 inputShort, ushort3 inputUShort, int3 inputInt, uint3 inputUInt, long3 inputLong, ulong3 inputULong, float3 inputFloat, double3 inputDouble, global float3* output) {
  output[hook(10, 0)] = convert_float3(inputChar);
  output[hook(10, 1)] = convert_float3(inputUChar);
  output[hook(10, 3)] = convert_float3(inputShort);
  output[hook(10, 3)] = convert_float3(inputUShort);
  output[hook(10, 4)] = convert_float3(inputInt);
  output[hook(10, 5)] = convert_float3(inputUInt);
  output[hook(10, 6)] = convert_float3(inputLong);
  output[hook(10, 7)] = convert_float3(inputULong);
  output[hook(10, 8)] = convert_float3(inputFloat);
  output[hook(10, 9)] = convert_float3(inputDouble);
}