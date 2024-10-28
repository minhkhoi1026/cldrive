//{"indices":4,"insOffset":5,"insStride":6,"popSize":0,"population":1,"sampSize":2,"samples":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct GridParams {
  float4 grid_size;
  float4 grid_min;
  float4 grid_max;
  float4 bnd_min;
  float4 bnd_max;

  float4 grid_res;
  float4 grid_delta;

  int nb_cells;
};

kernel void sample(int popSize, global float4* population, int sampSize, global float4* samples, global unsigned int* indices, unsigned int insOffset, unsigned int insStride

) {
  unsigned int index = get_global_id(0);
  if (index >= sampSize)
    return;
  unsigned int sample_index = indices[hook(4, index)];
  samples[hook(3, (index * insStride) + insOffset)] = (float)(sample_index < popSize) * population[hook(1, sample_index)];
}