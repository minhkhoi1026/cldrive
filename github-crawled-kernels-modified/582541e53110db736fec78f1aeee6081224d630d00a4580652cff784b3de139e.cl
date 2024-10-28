//{"constant_null":4,"factors":1,"input":2,"output":0,"scratch":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant uchar16 constant_vec = ((uchar16)(33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33));
kernel void read_memory(global char* output, constant int* factors, global int* input, local int* scratch) {
  local uchar16 local_vec;
  local long local_var;
  local_var = 44;
  int i = get_global_id(0);
  uchar16 private_vec = constant_vec;

  (&local_vec);
  (&local_var);
  (&i);
  (&private_vec);

  global unsigned int* global_null[8] = {0, 0, 0, 0, 0, 0, 0, &(*((global unsigned int*)0xffffff))};
  local unsigned int* local_null[8] = {0, 0, 0, 0, 0, 0, 0, &(*((local unsigned int*)0xffffff))};
  constant unsigned int* constant_null[8] = {0, 0, 0, 0, 0, 0, 0, &(*((constant unsigned int*)0xffffff))};
 private
  unsigned int* private_null[8] = {0, 0, 0, 0, 0, 0, 0, &(*((private unsigned int*)0xffffff))};
  *((global uchar16*)0xffffff) = private_vec;
  *((local uchar16*)0xffffff) = private_vec;
  *((private uchar16*)0xffffff) = private_vec;
  output[hook(0, 21)] = ((scratch[hook(3, 100)]) & 0xff) == 33;
  output[hook(0, 22)] = ((input[hook(2, 100)]) & 0xff) == 33;
  output[hook(0, 23)] = ((constant unsigned int*)&(factors[hook(1, 100)]) == constant_null[hook(4, 7)]);
  output[hook(0, 24)] = ((constant unsigned int*)&(factors[hook(1, 99)]) != constant_null[hook(4, 7)]);

  output[hook(0, 26)] = ((*(scratch - 1)) & 0xff) == 33;
  output[hook(0, 27)] = ((*(input - 1)) & 0xff) == 33;
  output[hook(0, 28)] = ((constant unsigned int*)&(*(&constant_vec - 1)) == constant_null[hook(4, 7)]);
}