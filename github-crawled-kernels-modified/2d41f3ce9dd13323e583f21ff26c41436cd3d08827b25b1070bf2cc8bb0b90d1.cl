//{"b":0,"b1":1,"b2":2,"error_msg":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
size_t my_strlen(constant char* str) {
  size_t len = 0;
  if (str)
    while (*str++)
      ++len;
  return len;
}

void my_strcpy(global char* dest, constant char* src, size_t n) {
  while (n--)
    *dest++ = *src++;
}

void set_error_msg(global char* error_msg, size_t error_msg_size, constant char* msg) {
  const size_t msg_len = my_strlen(msg);
  const size_t len = msg_len < error_msg_size ? msg_len : error_msg_size - 1;
  my_strcpy(error_msg, msg, len);
  error_msg[hook(3, len)] = 0;
}

kernel void DiamondDependencyTestDivision(global short* b, global int* b1, global int* b2) {
  const int index = get_global_id(0);
  b[hook(0, index)] *= b2[hook(2, index)] / b1[hook(1, index)];
}