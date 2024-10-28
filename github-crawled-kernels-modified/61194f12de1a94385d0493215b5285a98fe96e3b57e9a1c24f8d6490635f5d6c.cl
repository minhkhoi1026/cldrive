//{"Td0":6,"Td1":7,"Td2":8,"Td3":9,"Td4":10,"Tdg":1,"aes_key":2,"d_iv":3,"data":0,"out":4,"s":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AES256decKernel_cbc(global unsigned int* data, global unsigned int* Tdg, constant unsigned int* aes_key, global unsigned long* d_iv, global unsigned int* out) {
  local unsigned int t[256];
  local unsigned int s[256];
  s[hook(5, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = data[hook(0, (get_global_id(0) + mul24((int)get_global_id(1), (int)get_global_size(0))))] ^ aes_key[hook(2, get_local_id(0))];
  local unsigned int Td0[256];
  local unsigned int Td1[256];
  local unsigned int Td2[256];
  local unsigned int Td3[256];
  local unsigned char Td4[256];
  Td0[hook(6, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = Tdg[hook(1, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)) + 1024)];
  Td1[hook(7, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = Tdg[hook(1, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)) + 1280)];
  Td2[hook(8, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = Tdg[hook(1, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)) + 1536)];
  Td3[hook(9, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = Tdg[hook(1, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)) + 1792)];
  Td4[hook(10, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)))] = Tdg[hook(1, ((mul24(4, (int)get_local_id(1))) + get_local_id(0)) + 2048)];
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
  ;
  ;
}