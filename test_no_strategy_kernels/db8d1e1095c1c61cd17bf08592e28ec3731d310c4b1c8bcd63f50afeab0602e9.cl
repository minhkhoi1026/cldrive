//{"inputBuffer":0,"inputOffset":2,"inputStep":1,"outputBuffer":3,"outputOffset":5,"outputStep":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void shortToShort(global short* inputBuffer, long inputStep, long inputOffset, global short* outputBuffer, long outputStep, long outputOffset) {
  int gid = get_global_id(0);
  outputBuffer[hook(3, (gid * outputStep) + outputOffset)] = inputBuffer[hook(0, (gid * inputStep) + inputOffset)];
}