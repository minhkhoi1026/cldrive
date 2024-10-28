//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void switch_case(global int* input, global int* output) {
  int i = get_global_id(0);
  int in = input[hook(0, i)];
  int out;
  switch (in) {
    case 0:
      out = -7;
      break;
    case 1:
      out = i;
      break;
    case 2:
    case 3:
    case 4:
      out = in + i;
      break;
    default:
      out = 42;
      break;
  }

  output[hook(1, i)] = out;
}