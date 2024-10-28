//{"inputChar":0,"inputDouble":9,"inputFloat":8,"inputInt":4,"inputLong":6,"inputShort":2,"inputUChar":1,"inputUInt":5,"inputULong":7,"inputUShort":3,"output":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelVectorSixteen(char16 inputChar, uchar16 inputUChar, short16 inputShort, ushort16 inputUShort, int16 inputInt, uint16 inputUInt, long16 inputLong, ulong16 inputULong, float16 inputFloat, double16 inputDouble, global float16* output) {
  output[hook(10, 0)] = convert_float16(inputChar);
  output[hook(10, 1)] = convert_float16(inputUChar);
  output[hook(10, 2)] = convert_float16(inputShort);
  output[hook(10, 3)] = convert_float16(inputUShort);
  output[hook(10, 4)] = convert_float16(inputInt);
  output[hook(10, 5)] = convert_float16(inputUInt);
  output[hook(10, 6)] = convert_float16(inputLong);
  output[hook(10, 7)] = convert_float16(inputULong);
  output[hook(10, 8)] = convert_float16(inputFloat);
  output[hook(10, 9)] = convert_float16(inputDouble);
}