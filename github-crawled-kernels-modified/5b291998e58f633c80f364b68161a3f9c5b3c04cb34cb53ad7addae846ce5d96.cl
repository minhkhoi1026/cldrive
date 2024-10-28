//{"((__private float *)(&(Creg[wm][wn / 4])))":47,"Aptr":31,"Asub":30,"Asub[row + 0]":37,"Asub[row + 16]":38,"Asub[row + 32]":39,"Asub[row + 48]":40,"Asub[row]":29,"Bptr":34,"Breg":35,"Bsub":33,"Bsub[k]":36,"Bsub[row]":32,"Cptr":46,"Creg":28,"Creg[wm * 4 + 0]":41,"Creg[wm * 4 + 1]":42,"Creg[wm * 4 + 2]":43,"Creg[wm * 4 + 3]":44,"Creg[wm]":27,"Dptr":45,"K":25,"KG":24,"M":22,"MG":21,"N":23,"bias":26,"im_in":0,"im_out":2,"v_B_off":3,"v_C_off":4,"v_d_0":17,"v_d_1":18,"v_fin":19,"v_fout":20,"v_imsi":9,"v_imsi_0":5,"v_imsi_1":7,"v_imso":10,"v_imso_0":6,"v_imso_1":8,"v_k_0":11,"v_k_1":12,"v_p_0":13,"v_p_1":14,"v_s_0":15,"v_s_1":16,"wg":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_forward_with_bias(global const float* im_in, global const float* wg, global float* im_out, int v_B_off, int v_C_off, int v_imsi_0, int v_imso_0, int v_imsi_1, int v_imso_1, int v_imsi, int v_imso, int v_k_0, int v_k_1, int v_p_0, int v_p_1, int v_s_0, int v_s_1, int v_d_0, int v_d_1, int v_fin, int v_fout, int MG, int M, int N, int KG, int K, global const float* bias) {
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
  global const float* Dptr = bias;
  {
    float4 Creg[4][4 / 4];
    for (int wm = 0; wm < 4; ++wm) {
      for (int wn = 0; wn < 4 / 4; ++wn) {
        Creg[hook(28, wm)][hook(27, wn)].x = 0.0;
        Creg[hook(28, wm)][hook(27, wn)].y = 0.0;
        Creg[hook(28, wm)][hook(27, wn)].z = 0.0;
        Creg[hook(28, wm)][hook(27, wn)].w = 0.0;
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
              Asub[hook(30, row)][hook(29, col)] = Aptr[hook(31, (offM + row) * K + tiledIndex)];
            } else {
              Asub[hook(30, row)][hook(29, col)] = 0.0;
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
                Bsub[hook(33, row)][hook(32, col)] = Bptr[hook(34, tiledIndex)];
              } else {
                Bsub[hook(33, row)][hook(32, col)] = 0.0;
              }
            } else {
              Bsub[hook(33, row)][hook(32, col)] = 0.0;
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
              Breg[hook(35, wn)].x = Bsub[hook(33, k)][hook(36, col + 0)];
              Breg[hook(35, wn)].y = Bsub[hook(33, k)][hook(36, col + 16)];
              Breg[hook(35, wn)].z = Bsub[hook(33, k)][hook(36, col + 32)];
              Breg[hook(35, wn)].w = Bsub[hook(33, k)][hook(36, col + 48)];
            }
            for (int wm = 0; wm < 4 / 4; ++wm) {
              int row = tidm + wm * 4 * 16;
              Areg.x = Asub[hook(30, row + 0)][hook(37, k)];
              Areg.y = Asub[hook(30, row + 16)][hook(38, k)];
              Areg.z = Asub[hook(30, row + 32)][hook(39, k)];
              Areg.w = Asub[hook(30, row + 48)][hook(40, k)];
              for (int wn = 0; wn < 4 / 4; ++wn) {
                Creg[hook(28, wm * 4 + 0)][hook(41, wn)].x += Areg.x * Breg[hook(35, wn)].x;
                Creg[hook(28, wm * 4 + 1)][hook(42, wn)].x += Areg.y * Breg[hook(35, wn)].x;
                Creg[hook(28, wm * 4 + 2)][hook(43, wn)].x += Areg.z * Breg[hook(35, wn)].x;
                Creg[hook(28, wm * 4 + 3)][hook(44, wn)].x += Areg.w * Breg[hook(35, wn)].x;
                Creg[hook(28, wm * 4 + 0)][hook(41, wn)].y += Areg.x * Breg[hook(35, wn)].y;
                Creg[hook(28, wm * 4 + 1)][hook(42, wn)].y += Areg.y * Breg[hook(35, wn)].y;
                Creg[hook(28, wm * 4 + 2)][hook(43, wn)].y += Areg.z * Breg[hook(35, wn)].y;
                Creg[hook(28, wm * 4 + 3)][hook(44, wn)].y += Areg.w * Breg[hook(35, wn)].y;
                Creg[hook(28, wm * 4 + 0)][hook(41, wn)].z += Areg.x * Breg[hook(35, wn)].z;
                Creg[hook(28, wm * 4 + 1)][hook(42, wn)].z += Areg.y * Breg[hook(35, wn)].z;
                Creg[hook(28, wm * 4 + 2)][hook(43, wn)].z += Areg.z * Breg[hook(35, wn)].z;
                Creg[hook(28, wm * 4 + 3)][hook(44, wn)].z += Areg.w * Breg[hook(35, wn)].z;
                Creg[hook(28, wm * 4 + 0)][hook(41, wn)].w += Areg.x * Breg[hook(35, wn)].w;
                Creg[hook(28, wm * 4 + 1)][hook(42, wn)].w += Areg.y * Breg[hook(35, wn)].w;
                Creg[hook(28, wm * 4 + 2)][hook(43, wn)].w += Areg.z * Breg[hook(35, wn)].w;
                Creg[hook(28, wm * 4 + 3)][hook(44, wn)].w += Areg.w * Breg[hook(35, wn)].w;
              }
            }
          }
        }

        barrier(0x01);
      }
    }
    for (int wm = 0; wm < 4; ++wm) {
      int globalRow = offM + tidm + wm * 16;
      float biasval = Dptr[hook(45, globalRow)];
      for (int wn = 0; wn < 4; ++wn) {
        int globalCol = offN + tidn + wn * 16;
        if (globalRow < M && globalCol < N) {
          Cptr[hook(46, globalRow * N + globalCol)] = ((float*)(&(Creg[hook(28, wm)][hook(27, wn / 4)])))[hook(47, wn % 4)] + biasval;
        }
      }
    }
  }
}