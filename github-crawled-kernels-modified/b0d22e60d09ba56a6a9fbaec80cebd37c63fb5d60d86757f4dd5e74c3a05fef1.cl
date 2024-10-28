//{"Td0":4,"Td1":5,"Td2":6,"Td3":7,"Td4":8,"Tdg":1,"aes_key":2,"data":0,"s":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AES192decKernel(global unsigned int* data, global unsigned int* Tdg, constant unsigned int* aes_key) {
  local unsigned int t[256];
  local unsigned int s[256];
  s[hook(3, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = data[hook(0, (get_global_id(0) + mul24((int)get_global_id(1), (int)get_global_size(0))))] ^ aes_key[hook(2, get_local_id(0))];
  local unsigned int Td0[256];
  local unsigned int Td1[256];
  local unsigned int Td2[256];
  local unsigned int Td3[256];
  local unsigned char Td4[256];
  Td0[hook(4, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = Tdg[hook(1, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)) + 1024)];
  Td1[hook(5, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = Tdg[hook(1, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)) + 1280)];
  Td2[hook(6, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = Tdg[hook(1, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)) + 1536)];
  Td3[hook(7, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = Tdg[hook(1, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)) + 1792)];
  Td4[hook(8, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = Tdg[hook(1, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)) + 2048)];
  barrier(0x01);

  ;
  ;
  ;
  ;
  ;
  ;
  ;
  ;
  ;
  ;
  ;
  ;
}