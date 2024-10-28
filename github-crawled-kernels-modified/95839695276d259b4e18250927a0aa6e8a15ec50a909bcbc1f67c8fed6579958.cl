//{"input_buf":0,"input_ptr":2,"output_buf":1,"output_ptr":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct upsample_info {
  int max_v_samp_factor;
};

typedef unsigned char JSAMPLE;

kernel void my_upsample(global JSAMPLE* input_buf, global JSAMPLE* output_buf) {
  global JSAMPLE* input_ptr;
  global JSAMPLE* output_ptr;
  int invalue, othervalue;
  int yoffset = get_global_id(0);
  int height = get_global_size(0);
  int col = get_global_id(1);
  int width = get_global_size(1);

  input_ptr = input_buf + (yoffset * width) + col;
  output_ptr = output_buf + (((yoffset * width) + col) << 1);
  invalue = ((int)(input_ptr[hook(2, 0)]) & 0xFF);
  if (col == 0) {
    othervalue = ((int)(input_ptr[hook(2, 1)]) & 0xFF);
    output_ptr[hook(3, 0)] = invalue;
    output_ptr[hook(3, 1)] = (JSAMPLE)((invalue * 3 + othervalue + 2) >> 2);
  } else if (col == (width - 1)) {
    othervalue = ((int)(input_ptr[hook(2, -1)]) & 0xFF);
    output_ptr[hook(3, 0)] = (JSAMPLE)((invalue * 3 + othervalue + 1) >> 2);
    output_ptr[hook(3, 1)] = (JSAMPLE)invalue;
  } else {
    othervalue = ((int)(input_ptr[hook(2, -1)]) & 0xFF);
    output_ptr[hook(3, 0)] = (JSAMPLE)((invalue * 3 + othervalue + 1) >> 2);
    othervalue = ((int)(input_ptr[hook(2, 1)]) & 0xFF);
    output_ptr[hook(3, 1)] = (JSAMPLE)((invalue * 3 + othervalue + 2) >> 2);
  }
}