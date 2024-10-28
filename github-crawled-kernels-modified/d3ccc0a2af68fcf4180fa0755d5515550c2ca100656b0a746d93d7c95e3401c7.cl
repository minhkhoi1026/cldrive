//{"data":0,"dir":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bsort8(global float4* data, int dir) {
  float4 input1, input2, temp;
  int4 comp;

  uint4 mask1 = (uint4)(1, 0, 3, 2);
  uint4 mask2 = (uint4)(2, 3, 0, 1);
  uint4 mask3 = (uint4)(3, 2, 1, 0);

  int4 add1 = (int4)(1, 1, 3, 3);
  int4 add2 = (int4)(2, 3, 2, 3);
  int4 add3 = (int4)(1, 2, 2, 3);
  int4 add4 = (int4)(4, 5, 6, 7);

  input1 = data[hook(0, 0)];
  input2 = data[hook(0, 1)];

  comp = input1 < shuffle(input1, mask1) ^ 0;
  input1 = shuffle(input1, __builtin_astype((comp + add1), uint4));
  comp = input1 < shuffle(input1, mask2) ^ 0;
  input1 = shuffle(input1, __builtin_astype((comp * 2 + add2), uint4));
  comp = input1 < shuffle(input1, mask3) ^ 0;
  input1 = shuffle(input1, __builtin_astype((comp + add3), uint4));
  comp = input2 < shuffle(input2, mask1) ^ -1;
  input2 = shuffle(input2, __builtin_astype((comp + add1), uint4));
  comp = input2 < shuffle(input2, mask2) ^ -1;
  input2 = shuffle(input2, __builtin_astype((comp * 2 + add2), uint4));
  comp = input2 < shuffle(input2, mask3) ^ -1;
  input2 = shuffle(input2, __builtin_astype((comp + add3), uint4));

  temp = input1;
  comp = (input1 < input2 ^ dir) * 4 + add4;
  input1 = shuffle2(input1, input2, __builtin_astype((comp), uint4));
  input2 = shuffle2(input2, temp, __builtin_astype((comp), uint4));

  comp = input1 < shuffle(input1, mask1) ^ dir;
  input1 = shuffle(input1, __builtin_astype((comp + add1), uint4));
  comp = input1 < shuffle(input1, mask2) ^ dir;
  input1 = shuffle(input1, __builtin_astype((comp * 2 + add2), uint4));
  comp = input1 < shuffle(input1, mask3) ^ dir;
  input1 = shuffle(input1, __builtin_astype((comp + add3), uint4));
  comp = input2 < shuffle(input2, mask1) ^ dir;
  input2 = shuffle(input2, __builtin_astype((comp + add1), uint4));
  comp = input2 < shuffle(input2, mask2) ^ dir;
  input2 = shuffle(input2, __builtin_astype((comp * 2 + add2), uint4));
  comp = input2 < shuffle(input2, mask3) ^ dir;
  input2 = shuffle(input2, __builtin_astype((comp + add3), uint4));

  data[hook(0, 0)] = input1;
  data[hook(0, 1)] = input2;
}