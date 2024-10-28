//{"communicateBuffer":2,"num":0,"reasult":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reallySmallRSACrack(global int* num, global int* reasult, global int* communicateBuffer) {
  int targetNum = *num;
  int squareRoot = sqrt(convert_float(targetNum));
  int size = get_global_size(0);
  int id = get_global_id(0);
  int calcNum = squareRoot - id;

  for (int i = id; i < squareRoot && calcNum > 1;) {
    if (*communicateBuffer == 1)
      break;
    if (targetNum % calcNum == 0 && calcNum != 1) {
      *communicateBuffer = 1;
      reasult[hook(1, 0)] = calcNum;
      reasult[hook(1, 1)] = targetNum / calcNum;
      break;
    }
    calcNum -= size;
    i += size;
  }
}