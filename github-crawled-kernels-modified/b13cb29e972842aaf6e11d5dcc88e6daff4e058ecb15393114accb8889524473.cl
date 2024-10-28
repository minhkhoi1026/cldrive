//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float float4 __attribute__((ext_vector_type(4)));
typedef float float4 __attribute__((ext_vector_type(4)));
typedef double double4 __attribute__((ext_vector_type(4)));
kernel void testMiscOpenCLTypes() {
  const sampler_t scalarOCLSampler = 1 | 2 | 0x10;
  clk_event_t scalarOCLEvent;
  queue_t scalarOCLQueue;
  reserve_id_t scalarOCLReserveID;
}