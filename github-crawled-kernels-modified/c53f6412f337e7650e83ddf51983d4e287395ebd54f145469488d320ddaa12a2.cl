//{"axis":10,"input0":0,"input1":1,"input2":2,"input3":3,"input_shape0":5,"input_shape1":6,"input_shape2":7,"input_shape3":8,"output":4,"output_shape":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t smp_none = 0 | 0 | 0x10;
kernel void Concat4input_NC4HW4(read_only image2d_t input0, read_only image2d_t input1, read_only image2d_t input2, read_only image2d_t input3, write_only image2d_t output, int4 input_shape0, int4 input_shape1, int4 input_shape2, int4 input_shape3, int4 output_shape, const int axis) {
}