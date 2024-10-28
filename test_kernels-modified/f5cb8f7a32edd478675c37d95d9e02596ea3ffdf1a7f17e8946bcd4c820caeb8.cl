//{"emb_dim":3,"in_data":1,"out_count":6,"out_data":0,"padding_idx":5,"tabel":2,"word_num":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Embedding(global float* out_data, global const float* in_data, global const float* tabel, const int emb_dim, const int word_num, const int padding_idx, const int out_count) {
  int tid = get_global_id(0);

  if (tid < out_count) {
    int emb_id = tid % emb_dim;
    int word_id = tid / emb_dim;
    int word_idx_in_tabel = (int)(in_data[hook(1, word_id)]);

    if (word_idx_in_tabel != padding_idx) {
      out_data[hook(0, tid)] = (float)tabel[hook(2, word_idx_in_tabel * emb_dim + emb_id)];
    } else {
      out_data[hook(0, tid)] = (0.f);
    }
  }
}