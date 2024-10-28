//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelForTestingBadNameWithLengthHeigherThanOrEqualToTwoHundredAndFiftySixCharecterskernelToTestBadNameWithLengthHeigherThanOrEqualToTwoHundredAndFiftySixCharecterskernelToTestBadNameWithLengthHeigherThanOrEqualToTwoHundredAndFiftySixCharecterskernelName(global int* src, global int* dst) {
  dst[hook(1, 0)] = src[hook(0, 0)];
}