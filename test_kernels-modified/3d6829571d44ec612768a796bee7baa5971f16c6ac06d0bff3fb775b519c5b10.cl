//{"conversionGain":6,"inputBuffer":0,"inputOffset":2,"inputStep":1,"outputBuffer":3,"outputOffset":5,"outputStep":4,"overflowError":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floatToShort(global float* inputBuffer, long inputStep, long inputOffset, global short* outputBuffer, long outputStep, long outputOffset, float conversionGain, global int* overflowError) {
  int gid = get_global_id(0);

  float scale = 32767 * conversionGain;
  float f = inputBuffer[hook(0, (gid * inputStep) + inputOffset)] * scale;

  if (f > 32767) {
    f = 32767;
    *overflowError = 1;
  }

  if (f < (-32768)) {
    f = (-32768);
    *overflowError = 1;
  }

  outputBuffer[hook(3, (gid * outputStep) + outputOffset)] = convert_short(f);
}