//{"b":0,"error_msg":2,"v":1}
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
  error_msg[hook(2, len)] = 0;
}

kernel void DiamondDependencyTestFill(global short* b, short v) {
  const int index = get_global_id(0);
  b[hook(0, index)] = v;
}