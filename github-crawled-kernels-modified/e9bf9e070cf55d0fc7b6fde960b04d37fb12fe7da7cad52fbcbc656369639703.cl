//{"((__private float *)(&(Creg[wm][wn / 4])))":45,"Aptr":30,"Asub":29,"Asub[row + 0]":36,"Asub[row + 16]":37,"Asub[row + 32]":38,"Asub[row + 48]":39,"Asub[row]":28,"Bptr":33,"Breg":34,"Bsub":32,"Bsub[k]":35,"Bsub[row]":31,"Cptr":44,"Creg":27,"Creg[wm * 4 + 0]":40,"Creg[wm * 4 + 1]":41,"Creg[wm * 4 + 2]":42,"Creg[wm * 4 + 3]":43,"Creg[wm]":26,"K":25,"KG":24,"M":22,"MG":21,"N":23,"im_in":0,"im_out":2,"v_B_off":3,"v_C_off":4,"v_d_0":17,"v_d_1":18,"v_fin":19,"v_fout":20,"v_imsi":9,"v_imsi_0":5,"v_imsi_1":7,"v_imso":10,"v_imso_0":6,"v_imso_1":8,"v_k_0":11,"v_k_1":12,"v_p_0":13,"v_p_1":14,"v_s_0":15,"v_s_1":16,"wg":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_forward(global const float* restrict im_in, global const float* restrict wg, global float* restrict im_out, int v_B_off, int v_C_off, int v_imsi_0, int v_imso_0, int v_imsi_1, int v_imso_1, int v_imsi, int v_imso, int v_k_0, int v_k_1, int v_p_0, int v_p_1, int v_s_0, int v_s_1, int v_d_0, int v_d_1, int v_fin, int v_fout, int MG, int M, int N, int KG, int K) {
  int v_num_tiles = (((K - 1) / (8 * 2) + 1) * 2);
  const int tidn = get_local_id(0);
  const int tidm = get_local_id(1);
  const int offN = 64 * get_group_id(0);
  const int offM = 64 * get_group_id(1);
  volatile local float Asub[64][8 + 0];
  volatile local float Bsub[8][64 + 0];
  int batch = get_global_id(2);
  global const float* Aptr = wg;
  global const float* Bptr = im_in + v_B_off * batch;
  global float* Cptr = im_out + v_C_off * batch;
  {
    float4 Creg[4][4 / 4];
    for (int wm = 0; wm < 4; ++wm) {
      for (int wn = 0; wn < 4 / 4; ++wn) {
        Creg[hook(27, wm)][hook(26, wn)].x = 0.0;
        Creg[hook(27, wm)][hook(26, wn)].y = 0.0;
        Creg[hook(27, wm)][hook(26, wn)].z = 0.0;
        Creg[hook(27, wm)][hook(26, wn)].w = 0.0;
      }
    }
    {
      for (int t = 0; t < v_num_tiles; ++t) {
        {
          for (int la = 0; la < ((8 * 64) / (16 * 16)); ++la) {
            int tid = tidm * 16 + tidn;
            int id = la * 16 * 16 + tid;
            int row = id / 8;
            int col = id % 8;
            int tiledIndex = 8 * t + col;
            if ((offM + row) < M && tiledIndex < K) {
              Asub[hook(29, row)][hook(28, col)] = Aptr[hook(30, (offM + row) * K + tiledIndex)];
            } else {
              Asub[hook(29, row)][hook(28, col)] = 0.0;
            }
          }
        }
        {
          for (int lb = 0; lb < ((8 * 64) / (16 * 16)); ++lb) {
            int tid = tidm * 16 + tidn;
            int id = lb * 16 * 16 + tid;
            int col = id % 64;
            int row = id / 64;
            int tiledIndex = 8 * t + row;
            if ((offN + col) < N && tiledIndex < K) {
              int d_iter_0;
              int d_temp_0;
              int d_iter_1;
              int d_temp_1;
              int imageIndex = offN + col;
              d_iter_1 = (tiledIndex % v_k_1) * v_d_1;
              tiledIndex = tiledIndex / v_k_1;
              d_temp_1 = (imageIndex % v_imso_1) * v_s_1 - v_p_1;
              imageIndex = imageIndex / v_imso_1;
              d_iter_0 = (tiledIndex % v_k_0) * v_d_0;
              tiledIndex = tiledIndex / v_k_0;
              d_temp_0 = (imageIndex % v_imso_0) * v_s_0 - v_p_0;
              imageIndex = imageIndex / v_imso_0;
              bool in_range = true;
              int d_iter_im;
              d_iter_im = d_temp_0 + d_iter_0;
              tiledIndex = tiledIndex * v_imsi_0 + d_iter_im;
              in_range &= d_iter_im >= 0 && d_iter_im < v_imsi_0;
              d_iter_im = d_temp_1 + d_iter_1;
              tiledIndex = tiledIndex * v_imsi_1 + d_iter_im;
              in_range &= d_iter_im >= 0 && d_iter_im < v_imsi_1;
              if (in_range) {
                Bsub[hook(32, row)][hook(31, col)] = Bptr[hook(33, tiledIndex)];
              } else {
                Bsub[hook(32, row)][hook(31, col)] = 0.0;
              }
            } else {
              Bsub[hook(32, row)][hook(31, col)] = 0.0;
            }
          }
        }
        barrier(0x01);
        float4 Areg;
        float4 Breg[4 / 4];
        for (int kt = 0; kt < 8; kt += 1) {
          for (int ku = 0; ku < 1; ++ku) {
            int k = kt + ku;
            for (int wn = 0; wn < 4 / 4; ++wn) {
              int col = tidn + wn * 4 * 16;
              Breg[hook(34, wn)].x = Bsub[hook(32, k)][hook(35, col + 0)];
              Breg[hook(34, wn)].y = Bsub[hook(32, k)][hook(35, col + 16)];
              Breg[hook(34, wn)].z = Bsub[hook(32, k)][hook(35, col + 32)];
              Breg[hook(34, wn)].w = Bsub[hook(32, k)][hook(35, col + 48)];
            }
            for (int wm = 0; wm < 4 / 4; ++wm) {
              int row = tidm + wm * 4 * 16;
              Areg.x = Asub[hook(29, row + 0)][hook(36, k)];
              Areg.y = Asub[hook(29, row + 16)][hook(37, k)];
              Areg.z = Asub[hook(29, row + 32)][hook(38, k)];
              Areg.w = Asub[hook(29, row + 48)][hook(39, k)];
              for (int wn = 0; wn < 4 / 4; ++wn) {
                Creg[hook(27, wm * 4 + 0)][hook(40, wn)].x += Areg.x * Breg[hook(34, wn)].x;
                Creg[hook(27, wm * 4 + 1)][hook(41, wn)].x += Areg.y * Breg[hook(34, wn)].x;
                Creg[hook(27, wm * 4 + 2)][hook(42, wn)].x += Areg.z * Breg[hook(34, wn)].x;
                Creg[hook(27, wm * 4 + 3)][hook(43, wn)].x += Areg.w * Breg[hook(34, wn)].x;
                Creg[hook(27, wm * 4 + 0)][hook(40, wn)].y += Areg.x * Breg[hook(34, wn)].y;
                Creg[hook(27, wm * 4 + 1)][hook(41, wn)].y += Areg.y * Breg[hook(34, wn)].y;
                Creg[hook(27, wm * 4 + 2)][hook(42, wn)].y += Areg.z * Breg[hook(34, wn)].y;
                Creg[hook(27, wm * 4 + 3)][hook(43, wn)].y += Areg.w * Breg[hook(34, wn)].y;
                Creg[hook(27, wm * 4 + 0)][hook(40, wn)].z += Areg.x * Breg[hook(34, wn)].z;
                Creg[hook(27, wm * 4 + 1)][hook(41, wn)].z += Areg.y * Breg[hook(34, wn)].z;
                Creg[hook(27, wm * 4 + 2)][hook(42, wn)].z += Areg.z * Breg[hook(34, wn)].z;
                Creg[hook(27, wm * 4 + 3)][hook(43, wn)].z += Areg.w * Breg[hook(34, wn)].z;
                Creg[hook(27, wm * 4 + 0)][hook(40, wn)].w += Areg.x * Breg[hook(34, wn)].w;
                Creg[hook(27, wm * 4 + 1)][hook(41, wn)].w += Areg.y * Breg[hook(34, wn)].w;
                Creg[hook(27, wm * 4 + 2)][hook(42, wn)].w += Areg.z * Breg[hook(34, wn)].w;
                Creg[hook(27, wm * 4 + 3)][hook(43, wn)].w += Areg.w * Breg[hook(34, wn)].w;
              }
            }
          }
        }

        barrier(0x01);
      }
    }
    for (int wm = 0; wm < 4; ++wm) {
      int globalRow = offM + tidm + wm * 16;
      for (int wn = 0; wn < 4; ++wn) {
        int globalCol = offN + tidn + wn * 16;
        if (globalRow < M && globalCol < N) {
          Cptr[hook(44, globalRow * N + globalCol)] = ((float*)(&(Creg[hook(27, wm)][hook(26, wn / 4)])))[hook(45, wn % 4)];
        }
      }
    }
  }
}