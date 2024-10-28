//{"input":0,"n":3,"output":1,"temp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefixSum(global int* input, global int* output, local int* temp, int n) {
  int thid = get_global_id(0);
  int lthid = get_local_id(0);
  int pout = 0, pin = 1;

  temp[hook(2, lthid)] = input[hook(0, thid)];

  int offset = 1;
  for (int d = 1; d < n << 1; d <<= 1) {
    barrier(0x01);

    pout = 1 - pout;
    pin = 1 - pout;

    if ((lthid + 1) % (offset * 2) == 0) {
      temp[hook(2, (pout * n + lthid))] = temp[hook(2, (pin * n + lthid))] + temp[hook(2, (pin * n + lthid) - offset)];
    } else {
      temp[hook(2, (pout * n + lthid))] = temp[hook(2, pin * n + lthid)];
    }
    offset <<= 1;
  }
  if (lthid == n - 1) {
    temp[hook(2, (pout * n + lthid))] = 0;
  }
  offset = n;
  for (int d = 1; d < n << 1; d <<= 1) {
    barrier(0x01);
    pout = 1 - pout;
    pin = 1 - pout;

    if ((lthid + 1) % (offset) == 0) {
      int t = temp[hook(2, (pin * n + lthid))];
      int t2 = temp[hook(2, (pin * n + lthid) - offset / 2)];

      temp[hook(2, (pout * n + lthid))] = t + t2;
      temp[hook(2, (pout * n + lthid) - offset / 2)] = t;
    } else if ((lthid + 1) % (offset / 2) == 0) {
    } else {
      temp[hook(2, (pout * n + lthid))] = temp[hook(2, pin * n + lthid)];
    }
    offset >>= 1;
  }

  output[hook(1, thid)] = temp[hook(2, pout * n + lthid)];
}