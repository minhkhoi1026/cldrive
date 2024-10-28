//{"chn_6RB_filter_coef":3,"in":0,"len_in":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float chn_6RB_filter_coef[47] = {8.193313185354206e-04, 3.535548569572820e-04, -1.453429245341695e-03, 1.042805860697287e-03, 1.264224526451337e-03, -3.219586065044259e-03, 1.423981657254563e-03, 3.859884310477692e-03, -6.552708013395765e-03, 8.590509694961493e-04, 9.363722386299336e-03, -1.120357391780316e-02, -2.423088424232164e-03, 1.927528718829535e-02, -1.646405738285926e-02, -1.143040384534755e-02, 3.652830082843752e-02, -2.132986170036144e-02, -3.396829121834471e-02, 7.273086636811442e-02, -2.476823886110626e-02, -1.207789042999466e-01, 2.861583432079335e-01, 6.398255789896659e-01, 2.861583432079335e-01, -1.207789042999466e-01, -2.476823886110626e-02, 7.273086636811442e-02, -3.396829121834471e-02, -2.132986170036144e-02, 3.652830082843752e-02, -1.143040384534755e-02, -1.646405738285926e-02, 1.927528718829535e-02, -2.423088424232164e-03, -1.120357391780316e-02, 9.363722386299336e-03, 8.590509694961493e-04, -6.552708013395765e-03, 3.859884310477692e-03, 1.423981657254563e-03, -3.219586065044259e-03, 1.264224526451337e-03, 1.042805860697287e-03, -1.453429245341695e-03, 3.535548569572820e-04, 8.193313185354206e-04};

kernel void multi_filter(global float2* in, global float2* out, unsigned int len_in) {
  const size_t n = get_global_size(0);
  const size_t m = get_global_id(0);
  const size_t filter_len = sizeof(chn_6RB_filter_coef) / sizeof(float);
  const size_t sub_len_in = len_in / n;
  const size_t sub_len_out = sub_len_in + filter_len - 1;

  size_t i, j, base_idx;
  if (m == 0) {
    for (i = (sub_len_out - filter_len + 1); i < sub_len_out; i++) {
      base_idx = i * n;
      out[hook(1, base_idx)] = (float2)(0.0f, 0.0f);
    }
  }

  float2 acc;
  for (i = 0; i < filter_len - 1; i++) {
    acc = (float2)(0.0f, 0.0f);

    for (j = 0; j < i + 1; j++) {
      base_idx = j * n;
      acc = acc + in[hook(0, base_idx + m)] * chn_6RB_filter_coef[hook(3, (filter_len - 1) - i + j)];
    }

    base_idx = i * n;
    out[hook(1, base_idx + m + 1)] = acc;
  }

  for (i = filter_len - 1; i <= sub_len_in - 1; i++) {
    acc = (float2)(0.0f, 0.0f);

    for (j = 0; j < filter_len; j++) {
      base_idx = (i - (filter_len - 1) + j) * n;
      acc = acc + in[hook(0, base_idx + m)] * chn_6RB_filter_coef[hook(3, j)];
    }

    base_idx = i * n;
    out[hook(1, base_idx + m + 1)] = acc;
  }

  for (i = sub_len_in; i < sub_len_out; i++) {
    acc = (float2)(0.0f, 0.0f);

    for (j = 0; j < sub_len_out - i; j++) {
      base_idx = (i - (filter_len - 1) + j) * n;
      acc = acc + in[hook(0, base_idx + m)] * chn_6RB_filter_coef[hook(3, j)];
    }

    base_idx = i * n;
    out[hook(1, base_idx + m + 1)] = acc;
  }
}