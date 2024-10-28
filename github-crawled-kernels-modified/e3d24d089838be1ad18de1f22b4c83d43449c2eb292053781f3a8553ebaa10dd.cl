//{"inputChar":0,"inputDouble":9,"inputFloat":8,"inputInt":4,"inputLong":6,"inputShort":2,"inputUChar":1,"inputUInt":5,"inputULong":7,"inputUShort":3,"output":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelVectorEight(char8 inputChar, uchar8 inputUChar, short8 inputShort, ushort8 inputUShort, int8 inputInt, uint8 inputUInt, long8 inputLong, ulong8 inputULong, float8 inputFloat, double8 inputDouble, global float8* output) {
  output[hook(10, 0)] = convert_float8(inputChar);
  output[hook(10, 1)] = convert_float8(inputUChar);
  output[hook(10, 8)] = convert_float8(inputShort);
  output[hook(10, 8)] = convert_float8(inputUShort);
  output[hook(10, 8)] = convert_float8(inputInt);
  output[hook(10, 5)] = convert_float8(inputUInt);
  output[hook(10, 6)] = convert_float8(inputLong);
  output[hook(10, 7)] = convert_float8(inputULong);
  output[hook(10, 8)] = convert_float8(inputFloat);
  output[hook(10, 9)] = convert_float8(inputDouble);
}