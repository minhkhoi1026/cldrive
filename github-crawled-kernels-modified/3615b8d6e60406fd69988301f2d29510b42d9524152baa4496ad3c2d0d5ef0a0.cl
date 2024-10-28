//{"DCTbasis":10,"acc":1,"astride":6,"bstride":7,"data":9,"dx":3,"dy":4,"dz":5,"ldata":11,"set":8,"src":0,"thr":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float DCTbasis[] = {0.35355339059327373085750423342688009142875671386719f, 0.35355339059327373085750423342688009142875671386719f,  0.35355339059327373085750423342688009142875671386719f,  0.35355339059327373085750423342688009142875671386719f,  0.35355339059327373085750423342688009142875671386719f,  0.35355339059327373085750423342688009142875671386719f,  0.35355339059327373085750423342688009142875671386719f,  0.35355339059327373085750423342688009142875671386719f,

                             0.49039264020161521528962111915461719036102294921875f, 0.41573480615127261783570133957255166023969650268555f,  0.27778511650980114433551193542371038347482681274414f,  0.09754516100806412404189416065491968765854835510254f,  -0.09754516100806412404189416065491968765854835510254f, -0.27778511650980114433551193542371038347482681274414f, -0.41573480615127261783570133957255166023969650268555f, -0.49039264020161521528962111915461719036102294921875f,

                             0.46193976625564336924156805253005586564540863037109f, 0.19134171618254489088961634024599334225058555603027f,  -0.19134171618254489088961634024599334225058555603027f, -0.46193976625564336924156805253005586564540863037109f, -0.46193976625564336924156805253005586564540863037109f, -0.19134171618254489088961634024599334225058555603027f, 0.19134171618254489088961634024599334225058555603027f,  0.46193976625564336924156805253005586564540863037109f,

                             0.41573480615127261783570133957255166023969650268555f, -0.09754516100806417955304539191274670884013175964355f, -0.49039264020161521528962111915461719036102294921875f, -0.27778511650980108882436070416588336229324340820312f, 0.27778511650980108882436070416588336229324340820312f,  0.49039264020161521528962111915461719036102294921875f,  0.09754516100806417955304539191274670884013175964355f,  -0.41573480615127261783570133957255166023969650268555f,

                             0.35355339059327378636865546468470711261034011840820f, -0.35355339059327378636865546468470711261034011840820f, -0.35355339059327378636865546468470711261034011840820f, 0.35355339059327378636865546468470711261034011840820f,  0.35355339059327378636865546468470711261034011840820f,  -0.35355339059327378636865546468470711261034011840820f, -0.35355339059327378636865546468470711261034011840820f, 0.35355339059327378636865546468470711261034011840820f,

                             0.27778511650980114433551193542371038347482681274414f, -0.49039264020161532631192358167027123272418975830078f, 0.09754516100806412404189416065491968765854835510254f,  0.41573480615127261783570133957255166023969650268555f,  -0.41573480615127261783570133957255166023969650268555f, -0.09754516100806412404189416065491968765854835510254f, 0.49039264020161532631192358167027123272418975830078f,  -0.27778511650980114433551193542371038347482681274414f,

                             0.19134171618254491864519195587490685284137725830078f, -0.46193976625564336924156805253005586564540863037109f, 0.46193976625564336924156805253005586564540863037109f,  -0.19134171618254491864519195587490685284137725830078f, -0.19134171618254491864519195587490685284137725830078f, 0.46193976625564336924156805253005586564540863037109f,  -0.46193976625564336924156805253005586564540863037109f, 0.19134171618254491864519195587490685284137725830078f,

                             0.09754516100806416567525758409828995354473590850830f, -0.27778511650980108882436070416588336229324340820312f, 0.41573480615127267334685257083037868142127990722656f,  -0.49039264020161521528962111915461719036102294921875f, 0.49039264020161521528962111915461719036102294921875f,  -0.41573480615127267334685257083037868142127990722656f, 0.27778511650980108882436070416588336229324340820312f,  -0.09754516100806416567525758409828995354473590850830f};

float threshold(float v, float thr) {
  return fabs(v) < thr ? 0 : v;
}
void dct_forward_threshold(local float* data, int soff, int doff, int j, int stride, float thr) {
  float v = 0;
  for (int i = 0; i < 8; i++) {
    v += data[hook(9, i + soff)] * DCTbasis[hook(10, j * 8 + i)];
  }

  barrier(0x01);
  data[hook(9, j + soff)] = v;
  barrier(0x01);

  v = 0;
  for (int i = 0; i < 8; i++) {
    v += data[hook(9, i * stride + doff)] * DCTbasis[hook(10, j * 8 + i)];
  }

  v = threshold(v, thr);

  barrier(0x01);
  data[hook(9, j * stride + doff)] = v;
  barrier(0x01);
}

void dct_inverse(local float* data, int soff, int doff, int j, int stride) {
  float v = 0;

  for (int i = 0; i < 8; i++) {
    v += data[hook(9, i + soff)] * DCTbasis[hook(10, i * 8 + j)];
  }

  barrier(0x01);
  data[hook(9, j + soff)] = v;
  barrier(0x01);

  v = 0;
  for (int i = 0; i < 8; i++) {
    v += data[hook(9, i * stride + doff)] * DCTbasis[hook(10, i * 8 + j)];
  }

  barrier(0x01);
  data[hook(9, j * stride + doff)] = v;
  barrier(0x01);
}
kernel void __attribute__((reqd_work_group_size(8, 8, 8))) dct_denoise(read_only image3d_t src, global float* acc, float thr, int dx, int dy, int dz, int astride, int bstride, int set) {
  const sampler_t smp = 0 | 4 | 0x10;
  local float ldata[8 * (9) * (9)];
  int lx = get_local_id(0);
  int ly = get_local_id(1);
  int lz = get_local_id(2);

  int x = get_global_id(0) + dx;
  int y = get_global_id(1) + dy;
  int z = get_global_id(2) + dz;

  float v = read_imagef(src, smp, (int4){x, y, z, 0}).x;

  ldata[hook(11, lx + ly * (9) + lz * (9) * (9))] = v;

  barrier(0x01);
}