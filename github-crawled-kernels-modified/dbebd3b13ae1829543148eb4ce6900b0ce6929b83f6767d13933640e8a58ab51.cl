//{"inputChar":0,"inputDouble":9,"inputFloat":8,"inputInt":4,"inputLong":6,"inputShort":2,"inputUChar":1,"inputUInt":5,"inputULong":7,"inputUShort":3,"output":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelAllDatatypes(char inputChar, unsigned char inputUChar, short inputShort, unsigned short inputUShort, int inputInt, unsigned int inputUInt, long inputLong, unsigned long inputULong, float inputFloat, double inputDouble, global float* output) {
  output[hook(10, 0)] = convert_float(inputChar);
  output[hook(10, 1)] = convert_float(inputUChar);
  output[hook(10, 2)] = convert_float(inputShort);
  output[hook(10, 3)] = convert_float(inputUShort);
  output[hook(10, 4)] = convert_float(inputInt);
  output[hook(10, 5)] = convert_float(inputUInt);
  output[hook(10, 6)] = convert_float(inputLong);
  output[hook(10, 7)] = convert_float(inputULong);
  output[hook(10, 8)] = convert_float(inputFloat);
  output[hook(10, 9)] = convert_float(inputDouble);
}