//{"b1":0,"b2":1,"dim":5,"error_msg":6,"error_msg_size":7,"stride_x":2,"stride_y":3,"stride_z":4}
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
  error_msg[hook(6, len)] = 0;
}

kernel void TestArgumentPassing(global int* b1, global int* b2, int stride_x, int stride_y, int stride_z, int dim, global char* error_msg, int error_msg_size) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);

  if (dim < 2) {
    if (y != 0) {
      set_error_msg(error_msg, (size_t)error_msg_size, "Y dimension does not equal 0");
      return;
    }
    if (stride_y != 0) {
      set_error_msg(error_msg, (size_t)error_msg_size, "stride_y does not equal 0");
      return;
    }
  }

  if (dim < 3) {
    if (z != 0) {
      set_error_msg(error_msg, (size_t)error_msg_size, "Z dimension does not equal 0");
      return;
    }
    if (stride_z != 0) {
      set_error_msg(error_msg, (size_t)error_msg_size, "stride_z does not equal 0");
      return;
    }
  }

  const int index = x * stride_x + y * stride_y + z * stride_z;
  b2[hook(1, index)] = b1[hook(0, index)];

  set_error_msg(error_msg, (size_t)error_msg_size, "Done");
}