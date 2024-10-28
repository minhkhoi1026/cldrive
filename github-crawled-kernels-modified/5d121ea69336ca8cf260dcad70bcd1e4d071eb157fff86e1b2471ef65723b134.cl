//{"debugger":1,"numberjobs":2,"output":3,"seconds_input":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void superKernel(global int* seconds_input, global char* debugger, global int* numberjobs, global int* output) {
  float AddPerUs = 14846398.5;
  float adds = (*seconds_input) * AddPerUs;

  int t = get_global_id(0);
  int t2 = get_local_id(0);
  output[hook(3, t)] = t2;
  int loop = *numberjobs;
  int loop_temp;
  for (loop_temp = 0; loop_temp < loop; loop_temp++) {
    int temp = 0;
    while (temp < adds) {
      temp++;
    }
  }
  char enable;
  enable = '1';
  char test;
  test = 'b';
  debugger[hook(1, 0)] = enable;
  debugger[hook(1, 1)] = test;
}