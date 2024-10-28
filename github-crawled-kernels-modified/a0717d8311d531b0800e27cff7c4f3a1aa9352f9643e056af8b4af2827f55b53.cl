//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_branches(const global int* in, global int* out) {
  int tmp = *in;
  int result;
  bool test = tmp > 100;
  out[hook(1, 2)] = tmp;
  if (tmp > 1000) {
    result = 1000;
    out[hook(1, 3)] = result;
  } else if (test) {
    result = 100;
    out[hook(1, 3)] = result;
  } else {
    result = 10;
    out[hook(1, 3)] = result;
  }

  out[hook(1, 4)] = result;
  out[hook(1, 5)] = tmp;

  switch (tmp) {
    case 1024:
      result += 10;
      out[hook(1, 6)] = result;
      break;
    case 512:
      result += 9;
      out[hook(1, 7)] = result;
      break;
    case 256:
      result += 8;
      out[hook(1, 8)] = result;
      break;
    case 64:
      result += 6;
      out[hook(1, 9)] = result;
      break;
    case 32:
      result += 5;
      out[hook(1, 10)] = result;
      break;
    default:
      result += 1;
      out[hook(1, 11)] = result;
      break;
  }

  out[hook(1, 0)] = result;

  while (result < 1024) {
    result *= 2;
    result += 7;
  }
  out[hook(1, 1)] = result;
}