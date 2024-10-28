//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float float4 __attribute__((ext_vector_type(4)));
typedef float float4 __attribute__((ext_vector_type(4)));
typedef double double4 __attribute__((ext_vector_type(4)));

kernel void OCLImage1dWOTest(write_only image1d_t scalarOCLImage1dWO);