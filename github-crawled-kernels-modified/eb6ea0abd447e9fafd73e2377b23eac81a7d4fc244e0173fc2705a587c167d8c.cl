//{"inptr0":2,"inptr1":3,"input_buf":0,"outptr":4,"output_buf":1}
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
  global JSAMPLE* inptr0;
  global JSAMPLE* inptr1;

  global JSAMPLE* input_ptr;
  global JSAMPLE* outptr;
  int invalue;
  int yoffset = get_global_id(0);
  int height = get_global_size(0);
  int col = get_global_id(1);
  int width = get_global_size(1);
  int input_offset = ((yoffset >> 1) * width) + col;

  inptr0 = input_buf + input_offset;
  if (yoffset == 0) {
    inptr1 = inptr0;
  } else if (yoffset == (height - 1)) {
    inptr1 = inptr0;
  } else if (!(yoffset & 1)) {
    inptr1 = inptr0 - width;
  } else {
    inptr1 = inptr0 + width;
  }
  outptr = output_buf + (((yoffset * width) + col) << 1);

  if (col == 0) {
    unsigned int thiscolsum = ((int)(inptr0[hook(2, 0)]) & 0xFF) * 3 + ((int)(inptr1[hook(3, 0)]) & 0xFF);
    unsigned int nextcolsum = ((int)(inptr0[hook(2, 1)]) & 0xFF) * 3 + ((int)(inptr1[hook(3, 1)]) & 0xFF);
    outptr[hook(4, 0)] = (JSAMPLE)((thiscolsum * 4 + 8) >> 4);
    outptr[hook(4, 1)] = (JSAMPLE)((thiscolsum * 3 + nextcolsum + 7) >> 4);
  } else if (col == (width - 1)) {
    unsigned int thiscolsum = ((int)(inptr0[hook(2, 0)]) & 0xFF) * 3 + ((int)(inptr1[hook(3, 0)]) & 0xFF);
    unsigned int lastcolsum = ((int)(inptr0[hook(2, -1)]) & 0xFF) * 3 + ((int)(inptr1[hook(3, -1)]) & 0xFF);
    outptr[hook(4, 0)] = (JSAMPLE)((thiscolsum * 3 + lastcolsum + 8) >> 4);
    outptr[hook(4, 1)] = (JSAMPLE)((thiscolsum * 4 + 7) >> 4);
  } else {
    unsigned int lastcolsum = ((int)(inptr0[hook(2, -1)]) & 0xFF) * 3 + ((int)(inptr1[hook(3, -1)]) & 0xFF);
    unsigned int thiscolsum = ((int)(inptr0[hook(2, 0)]) & 0xFF) * 3 + ((int)(inptr1[hook(3, 0)]) & 0xFF);
    unsigned int nextcolsum = ((int)(inptr0[hook(2, 1)]) & 0xFF) * 3 + ((int)(inptr1[hook(3, 1)]) & 0xFF);
    outptr[hook(4, 0)] = (JSAMPLE)((thiscolsum * 3 + lastcolsum + 8) >> 4);
    outptr[hook(4, 1)] = (JSAMPLE)((thiscolsum * 3 + nextcolsum + 7) >> 4);
  }
}