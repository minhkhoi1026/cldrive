//{"((__global unsigned int *)(R + 16))":11,"((__global unsigned int *)(R + 17))":12,"((__global unsigned int *)(R + 19))":13,"A":10,"R":9,"batch_size":4,"e":6,"entropy":0,"intermediate_programs":2,"p0":5,"prefecth_vgprs_stack":7,"prefetched_vgprs":8,"programs":3,"registers":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double getSmallPositiveFloatBits(const ulong entropy) {
  ulong exponent = entropy >> 59;
  ulong mantissa = entropy & ((1UL << 52) - 1);
  exponent += 1023;
  exponent &= ((1UL << 11) - 1);
  exponent <<= 52;
  return __builtin_astype((exponent | mantissa), double);
}

ulong getStaticExponent(const ulong entropy) {
  ulong exponent = 0x300;
  exponent |= (entropy >> (64 - 4)) << 4;
  exponent <<= 52;
  return exponent;
}

ulong getFloatMask(const ulong entropy) {
  const unsigned int mask22bit = (1U << 22) - 1;
  return (entropy & mask22bit) | getStaticExponent(entropy);
}

global unsigned int* jit_scratchpad_calc_address(global unsigned int* p, unsigned int src, unsigned int imm32, unsigned int mask_reg, unsigned int batch_size) {
  *(p++) = 0x810eff10u | (src << 1);
  *(p++) = imm32;

  *(p++) = 0x2638000eu | (mask_reg << 9);

  return p;
}

global unsigned int* jit_scratchpad_calc_fixed_address(global unsigned int* p, unsigned int imm32, unsigned int batch_size) {
  *(p++) = 0x7e3802ffu;
  *(p++) = imm32;

  return p;
}

global unsigned int* jit_scratchpad_load(global unsigned int* p, unsigned int vgpr_index) {
  *(p++) = 0x32543902u;
  *(p++) = 0xd11c6a2bu;
  *(p++) = 0x01a90103u;
  *(p++) = 0xdc540000u;
  *(p++) = 0x0000002au | (vgpr_index << 24);

  return p;
}

global unsigned int* jit_scratchpad_load2(global unsigned int* p, unsigned int vgpr_index, int vmcnt) {
  if (vmcnt >= 0)
    *(p++) = 0xbf8c0f70u | (vmcnt & 15) | ((vmcnt >> 4) << 14);

  *(p++) = 0xd2890000u | 14;
  *(p++) = 0x00010100u | vgpr_index;

  *(p++) = 0xd2890000u | 15;
  *(p++) = 0x00010100u | (vgpr_index + 1);

  return p;
}

global unsigned int* jit_scratchpad_calc_address_fp(global unsigned int* p, unsigned int src, unsigned int imm32, unsigned int mask_reg, unsigned int batch_size) {
  *(p++) = 0x810eff10u | (src << 1);
  *(p++) = imm32;

  *(p++) = 0x26000000u | 0x38000eu | (mask_reg << 9);
  *(p++) = 0x3238591cu;

  return p;
}

global unsigned int* jit_scratchpad_load_fp(global unsigned int* p, unsigned int vgpr_index) {
  *(p++) = 0x32543902u;
  *(p++) = 0xd11c6a2bu;
  *(p++) = 0x01a90103u;
  *(p++) = 0xdc500000u;
  *(p++) = 0x0000002au | (vgpr_index << 24);

  return p;
}

global unsigned int* jit_scratchpad_load2_fp(global unsigned int* p, unsigned int vgpr_index, int vmcnt) {
  if (vmcnt >= 0)
    *(p++) = 0xbf8c0f70u | (vmcnt & 15) | ((vmcnt >> 4) << 14);

  *(p++) = 0x7e380900u | vgpr_index;

  return p;
}

ulong imul_rcp_value(unsigned int divisor) {
  const ulong p2exp63 = 1UL << 63;

  ulong quotient = p2exp63 / divisor;
  ulong remainder = p2exp63 % divisor;

  const unsigned int bsr = 31 - clz(divisor);

  for (unsigned int shift = 0; shift <= bsr; ++shift) {
    const bool b = (remainder >= divisor - remainder);
    quotient = (quotient << 1) | (b ? 1 : 0);
    remainder = (remainder << 1) - (b ? divisor : 0);
  }

  return quotient;
}

global unsigned int* jit_emit_instruction(global unsigned int* p, global unsigned int* last_branch_target, const uint2 inst, int prefetch_vgpr_index, int vmcnt, unsigned int batch_size) {
  unsigned int opcode = inst.x & 0xFF;
  const unsigned int dst = (inst.x >> 8) & 7;
  const unsigned int src = (inst.x >> 16) & 7;
  const unsigned int mod = inst.x >> 24;

  if (opcode < 16) {
    const unsigned int shift = (mod >> 2) % 4;
    if (shift > 0) {
      *(p++) = 0x8e000000u | 0x8e8010u | (src << 1) | (shift << 8);

      *(p++) = 0x80100e10u | (dst << 1) | (dst << 17);

      *(p++) = 0x82110f11u | (dst << 1) | (dst << 17);
    } else {
      *(p++) = 0x80101010u | (dst << 1) | (dst << 17) | (src << 9);

      *(p++) = 0x82111111u | (dst << 1) | (dst << 17) | (src << 9);
    }

    if (dst == 5) {
      *(p++) = 0x8010ff10u | (dst << 1) | (dst << 17);
      *(p++) = inst.y;

      *(p++) = 0x82110011u | (dst << 1) | (dst << 17) | (((__builtin_astype((inst.y), int) < 0) ? 0xc1 : 0x80) << 8);
    }

    return p;
  }
  opcode -= 16;

  if (opcode < 7) {
    if (prefetch_vgpr_index >= 0) {
      if (src != dst)
        p = jit_scratchpad_calc_address(p, src, inst.y, (mod % 4) ? 38 : 39, batch_size);
      else
        p = jit_scratchpad_calc_fixed_address(p, inst.y & (2097152 - 8), batch_size);

      p = jit_scratchpad_load(p, prefetch_vgpr_index ? prefetch_vgpr_index : 28);
    }

    if (prefetch_vgpr_index <= 0) {
      p = jit_scratchpad_load2(p, prefetch_vgpr_index ? -prefetch_vgpr_index : 28, prefetch_vgpr_index ? vmcnt : 0);

      *(p++) = 0x80100e10u | (dst << 1) | (dst << 17);

      *(p++) = 0x82110f11u | (dst << 1) | (dst << 17);
    }

    return p;
  }
  opcode -= 7;

  if (opcode < 16) {
    if (src != dst) {
      *(p++) = 0x80901010u | (dst << 1) | (dst << 17) | (src << 9);

      *(p++) = 0x82911111u | (dst << 1) | (dst << 17) | (src << 9);
    } else {
      *(p++) = 0x8090ff10u | (dst << 1) | (dst << 17);
      *(p++) = inst.y;

      *(p++) = 0x82910011u | (dst << 1) | (dst << 17) | (((__builtin_astype((inst.y), int) < 0) ? 0xc1 : 0x80) << 8);
    }

    return p;
  }
  opcode -= 16;

  if (opcode < 7) {
    if (prefetch_vgpr_index >= 0) {
      if (src != dst)
        p = jit_scratchpad_calc_address(p, src, inst.y, (mod % 4) ? 38 : 39, batch_size);
      else
        p = jit_scratchpad_calc_fixed_address(p, inst.y & (2097152 - 8), batch_size);

      p = jit_scratchpad_load(p, prefetch_vgpr_index ? prefetch_vgpr_index : 28);
    }

    if (prefetch_vgpr_index <= 0) {
      p = jit_scratchpad_load2(p, prefetch_vgpr_index ? -prefetch_vgpr_index : 28, prefetch_vgpr_index ? vmcnt : 0);

      *(p++) = 0x80900e10u | (dst << 1) | (dst << 17);

      *(p++) = 0x82910f11u | (dst << 1) | (dst << 17);
    }

    return p;
  }
  opcode -= 7;

  if (opcode < 16) {
    if (src != dst) {
      *(p++) = 0x7e380210u | (dst << 1);

      *(p++) = 0xd286001cu;
      *(p++) = 0x0000211cu + (src << 10);

      *(p++) = 0xd289000fu;
      *(p++) = 0x0001011cu;

      *(p++) = 0x92000000u | 0x0e1110u | (dst << 1) | (src << 9);

      *(p++) = 0x800f0e0fu;

      *(p++) = 0x92000000u | 0x0e1011u | (dst << 1) | (src << 9);

      *(p++) = 0x80110e0fu | (dst << 17);

      *(p++) = 0x92000000u | 0x101010u | (dst << 1) | (dst << 17) | (src << 9);
    } else {
      *(p++) = 0x7e3802ffu;
      *(p++) = inst.y;

      *(p++) = 0xd286001cu;
      *(p++) = 0x0000211cu + (dst << 10);

      *(p++) = 0xd289000fu;
      *(p++) = 0x0001011cu;

      if (__builtin_astype((inst.y), int) < 0) {
        *(p++) = 0x808f100fu | (dst << 9);
      }

      *(p++) = 0x92000000u | 0x0eff11u | (dst << 1);
      *(p++) = inst.y;

      *(p++) = 0x80110e0fu | (dst << 17);

      *(p++) = 0x92000000u | 0x10ff10u | (dst << 1) | (dst << 17);
      *(p++) = inst.y;
    }

    return p;
  }
  opcode -= 16;

  if (opcode < 4) {
    if (prefetch_vgpr_index >= 0) {
      if (src != dst)
        p = jit_scratchpad_calc_address(p, src, inst.y, (mod % 4) ? 38 : 39, batch_size);
      else
        p = jit_scratchpad_calc_fixed_address(p, inst.y & (2097152 - 8), batch_size);

      p = jit_scratchpad_load(p, prefetch_vgpr_index ? prefetch_vgpr_index : 28);
    }

    if (prefetch_vgpr_index <= 0) {
      p = jit_scratchpad_load2(p, prefetch_vgpr_index ? -prefetch_vgpr_index : 28, prefetch_vgpr_index ? vmcnt : 0);

      *(p++) = 0x7e380210u | (dst << 1);

      *(p++) = 0xd286001cu;
      *(p++) = 0x00001d1cu;

      *(p++) = 0xd2890021u;
      *(p++) = 0x0001011cu;

      *(p++) = 0x92000000u | 0x200f10u | (dst << 1);

      *(p++) = 0x80212021u;

      *(p++) = 0x92000000u | 0x200e11u | (dst << 1);

      *(p++) = 0x80112021u | (dst << 17);

      *(p++) = 0x92000000u | 0x100e10u | (dst << 1) | (dst << 17);
    }

    return p;
  }
  opcode -= 4;

  if (opcode < 4) {
    *(p++) = 0xbe8e0110u | (dst << 1);
    *(p++) = 0xbea60110u | (src << 1);
    *(p++) = 0xbebc1e3au;
    *(p++) = 0xbe90010eu | (dst << 17);

    return p;
  }
  opcode -= 4;

  if (opcode < 1) {
    if (prefetch_vgpr_index >= 0) {
      if (src != dst)
        p = jit_scratchpad_calc_address(p, src, inst.y, (mod % 4) ? 38 : 39, batch_size);
      else
        p = jit_scratchpad_calc_fixed_address(p, inst.y & (2097152 - 8), batch_size);

      p = jit_scratchpad_load(p, prefetch_vgpr_index ? prefetch_vgpr_index : 28);
    }

    if (prefetch_vgpr_index <= 0) {
      p = jit_scratchpad_load2(p, prefetch_vgpr_index ? -prefetch_vgpr_index : 28, prefetch_vgpr_index ? vmcnt : 0);

      *(p++) = 0xbea60110u | (dst << 1);
      *(p++) = 0xbebc1e3au;
      *(p++) = 0xbe90010eu | (dst << 17);
    }

    return p;
  }
  opcode -= 1;

  if (opcode < 4) {
    *(p++) = 0xbe8e0110u | (dst << 1);
    *(p++) = 0xbea60110u | (src << 1);
    *(p++) = 0xbebc1e38u;
    *(p++) = 0xbe90010eu | (dst << 17);

    return p;
  }
  opcode -= 4;

  if (opcode < 1) {
    if (prefetch_vgpr_index >= 0) {
      if (src != dst)
        p = jit_scratchpad_calc_address(p, src, inst.y, (mod % 4) ? 38 : 39, batch_size);
      else
        p = jit_scratchpad_calc_fixed_address(p, inst.y & (2097152 - 8), batch_size);

      p = jit_scratchpad_load(p, prefetch_vgpr_index ? prefetch_vgpr_index : 28);
    }

    if (prefetch_vgpr_index <= 0) {
      p = jit_scratchpad_load2(p, prefetch_vgpr_index ? -prefetch_vgpr_index : 28, prefetch_vgpr_index ? vmcnt : 0);

      *(p++) = 0xbea60110u | (dst << 1);
      *(p++) = 0xbebc1e38u;
      *(p++) = 0xbe90010eu | (dst << 17);
    }

    return p;
  }
  opcode -= 1;

  if (opcode < 8) {
    if (inst.y & (inst.y - 1)) {
      const uint2 rcp_value = __builtin_astype((imul_rcp_value(inst.y)), uint2);

      *(p++) = 0xbea000ffu;
      *(p++) = rcp_value.x;

      *(p++) = 0x7e380220u;

      *(p++) = 0xd286001cu;
      *(p++) = 0x0000211cu + (dst << 10);

      *(p++) = 0xd289000fu;
      *(p++) = 0x0001011cu;

      *(p++) = 0x92000000u | 0x0eff10u | (dst << 1);
      *(p++) = rcp_value.y;
      *(p++) = 0x800f0e0fu;
      *(p++) = 0x92000000u | 0x0e2011u | (dst << 1);
      *(p++) = 0x80110e0fu | (dst << 17);
      *(p++) = 0x92000000u | 0x102010u | (dst << 1) | (dst << 17);
    }

    return p;
  }
  opcode -= 8;

  if (opcode < 2) {
    *(p++) = 0x80901080u | (dst << 9) | (dst << 17);
    *(p++) = 0x82911180u | (dst << 9) | (dst << 17);

    return p;
  }
  opcode -= 2;

  if (opcode < 15) {
    if (src != dst) {
      *(p++) = 0x88000000u | 0x901010u | (dst << 1) | (dst << 17) | (src << 9);
    } else {
      if (__builtin_astype((inst.y), int) < 0) {
        *(p++) = 0xbebe00ffu;
        *(p++) = inst.y;

        *(p++) = 0x88000000u | 0x903e10u | (dst << 1) | (dst << 17);
      } else {
        *(p++) = 0x88000000u | 0x10ff10u | (dst << 1) | (dst << 17);
        *(p++) = inst.y;
      }
    }

    return p;
  }
  opcode -= 15;

  if (opcode < 5) {
    if (prefetch_vgpr_index >= 0) {
      if (src != dst)
        p = jit_scratchpad_calc_address(p, src, inst.y, (mod % 4) ? 38 : 39, batch_size);
      else
        p = jit_scratchpad_calc_fixed_address(p, inst.y & (2097152 - 8), batch_size);

      p = jit_scratchpad_load(p, prefetch_vgpr_index ? prefetch_vgpr_index : 28);
    }

    if (prefetch_vgpr_index <= 0) {
      p = jit_scratchpad_load2(p, prefetch_vgpr_index ? -prefetch_vgpr_index : 28, prefetch_vgpr_index ? vmcnt : 0);

      *(p++) = 0x88000000u | 0x900e10u | (dst << 1) | (dst << 17);
    }

    return p;
  }
  opcode -= 5;

  if (opcode < 8 + 2) {
    if (src != dst) {
      if (opcode < 8) {
        *(p++) = 0x8f000000u | 0xa01010u | (dst << 1) | (src << 9);

        *(p++) = 0x808f10c0u | (src << 9);

        *(p++) = 0x8e000000u | 0xa20f10u | (dst << 1);
      } else {
        *(p++) = 0x8e000000u | 0xa01010u | (dst << 1) | (src << 9);

        *(p++) = 0x808f10c0u | (src << 9);

        *(p++) = 0x8f000000u | 0xa20f10u | (dst << 1);
      }
    } else {
      const unsigned int shift = ((opcode < 8) ? inst.y : -inst.y) & 63;

      *(p++) = 0x8f000000u | 0xa08010u | (dst << 1) | (shift << 8);

      *(p++) = 0x8e000000u | 0xa28010u | (dst << 1) | ((64 - shift) << 8);
    }

    *(p++) = 0x87000000u | 0x902220u | (dst << 17);

    return p;
  }
  opcode -= 8 + 2;

  if (opcode < 4) {
    if (src != dst) {
      *(p++) = 0xbea00110u | (dst << 1);
      *(p++) = 0xbe900110u | (src << 1) | (dst << 17);
      *(p++) = 0xbe900120u | (src << 17);
    }

    return p;
  }
  opcode -= 4;

  if (opcode < 4) {
    *(p++) = 0xd87a8001u;
    *(p++) = 0x3c00003cu + (dst << 1) + (dst << 25);

    *(p++) = 0xd87a8001u;
    *(p++) = 0x3d00003du + (dst << 1) + (dst << 25);

    *(p++) = 0xbf8cc07fu;

    return p;
  }
  opcode -= 4;

  if (opcode < 16) {
    *(p++) = 0xd280003cu + ((dst & 3) << 1);
    *(p++) = 0x0002693cu + ((dst & 3) << 1) + ((src & 3) << 10);

    return p;
  }
  opcode -= 16;

  if (opcode < 5) {
    if (prefetch_vgpr_index >= 0) {
      p = jit_scratchpad_calc_address_fp(p, src, inst.y, (mod % 4) ? 38 : 39, batch_size);
      p = jit_scratchpad_load_fp(p, prefetch_vgpr_index ? prefetch_vgpr_index : 28);
    }

    if (prefetch_vgpr_index <= 0) {
      p = jit_scratchpad_load2_fp(p, prefetch_vgpr_index ? -prefetch_vgpr_index : 28, prefetch_vgpr_index ? vmcnt : 0);

      *(p++) = 0xd280003cu + ((dst & 3) << 1);
      *(p++) = 0x0002393cu + ((dst & 3) << 1);
    }

    return p;
  }
  opcode -= 5;

  if (opcode < 16) {
    *(p++) = 0xd280003cu + ((dst & 3) << 1);
    *(p++) = 0x4002693cu + ((dst & 3) << 1) + ((src & 3) << 10);

    return p;
  }
  opcode -= 16;

  if (opcode < 5) {
    if (prefetch_vgpr_index >= 0) {
      p = jit_scratchpad_calc_address_fp(p, src, inst.y, (mod % 4) ? 38 : 39, batch_size);
      p = jit_scratchpad_load_fp(p, prefetch_vgpr_index ? prefetch_vgpr_index : 28);
    }

    if (prefetch_vgpr_index <= 0) {
      p = jit_scratchpad_load2_fp(p, prefetch_vgpr_index ? -prefetch_vgpr_index : 28, prefetch_vgpr_index ? vmcnt : 0);

      *(p++) = 0xd280003cu + ((dst & 3) << 1);
      *(p++) = 0x4002393cu + ((dst & 3) << 1);
    }

    return p;
  }
  opcode -= 5;

  if (opcode < 6) {
    *(p++) = (0x2a000000u | 0x7a673du) + ((dst & 3) << 1) + ((dst & 3) << 18);

    return p;
  }
  opcode -= 6;

  if (opcode < 32) {
    *(p++) = 0xd2810044u + ((dst & 3) << 1);
    *(p++) = 0x00026944u + ((dst & 3) << 1) + ((src & 3) << 10);

    return p;
  }
  opcode -= 32;

  if (opcode < 4) {
    if (prefetch_vgpr_index >= 0) {
      p = jit_scratchpad_calc_address_fp(p, src, inst.y, (mod % 4) ? 38 : 39, batch_size);
      p = jit_scratchpad_load_fp(p, prefetch_vgpr_index ? prefetch_vgpr_index : 28);
    }

    if (prefetch_vgpr_index <= 0) {
      p = jit_scratchpad_load2_fp(p, prefetch_vgpr_index ? -prefetch_vgpr_index : 28, prefetch_vgpr_index ? vmcnt : 0);

      *(p++) = 0xbebc1e30u + ((dst & 3) << 1);
    }

    return p;
  }
  opcode -= 4;

  if (opcode < 6) {
    *(p++) = 0xbebc1e28u + ((dst & 3) << 1);

    return p;
  }
  opcode -= 6;

  if (opcode < 25) {
    const int shift = (mod >> 4) + 8;
    unsigned int imm = inst.y | (1u << shift);
    imm &= ~(1u << (shift - 1));

    *(p++) = 0x8010ff10 | (dst << 1) | (dst << 17);
    *(p++) = imm;

    *(p++) = 0x82110011u | (dst << 1) | (dst << 17) | (((__builtin_astype((imm), int) < 0) ? 0xc1 : 0x80) << 8);

    const unsigned int conditionMaskReg = 70 + (mod >> 4);

    *(p++) = 0x86000000u | 0x0e0010u | (dst << 1) | (conditionMaskReg << 8);

    const int delta = ((last_branch_target - p) - 1);
    *(p++) = 0xbf840000u | (delta & 0xFFFF);

    return p;
  }
  opcode -= 25;

  if (opcode < 1) {
    const unsigned int shift = inst.y & 63;
    if (shift == 63) {
      *(p++) = 0x8e000000u | 0x0e8110u | (src << 1);
      *(p++) = 0x8f000000u | 0x0f9f11u | (src << 1);
      *(p++) = 0x87000000u | 0x0e0f0eu;
      *(p++) = 0x86000000u | 0x0e830eu;
    } else {
      *(p++) = 0x93000000u | 0x8eff10u | (src << 1);
      *(p++) = shift | (2 << 16);
    }
    *(p++) = 0xbe8e080eu;
    *(p++) = 0x8f429e0eu;
    *(p++) = 0xb9420881u;

    return p;
  }
  opcode -= 1;

  if (opcode < 16) {
    const unsigned int mask = ((mod >> 4) < 14) ? ((mod % 4) ? 38 : 39) : 50;
    p = jit_scratchpad_calc_address(p, dst, inst.y, mask, batch_size);

    const unsigned int vgpr_id = 48;
    *(p++) = 0x7e000210u | (src << 1) | (vgpr_id << 17);
    *(p++) = 0x7e020211u | (src << 1) | (vgpr_id << 17);
    *(p++) = 0x3238051cu;

    *(p++) = 0x383a0680u;

    *(p++) = 0xdc740000u;
    *(p++) = 0x0000001cu | (vgpr_id << 8);

    return p;
  }
  opcode -= 16;

  return p;
}

int jit_prefetch_read(global uint2* p0, const int prefetch_data_count, const unsigned int i, const unsigned int src, const unsigned int dst, const uint2 inst, const unsigned int srcAvailableAt, const unsigned int scratchpadAvailableAt, const unsigned int scratchpadHighAvailableAt, const int lastBranchTarget, const int lastBranch) {
  uint2 t;
  t.x = (src == dst) ? (((inst.y & (2097152 - 8)) >= 262144) ? scratchpadHighAvailableAt : scratchpadAvailableAt) : max(scratchpadAvailableAt, srcAvailableAt);
  t.y = i;

  const int t1 = t.x;

  if ((lastBranchTarget <= t1) && (t1 <= lastBranch)) {
    t.x = lastBranch + 1;
  } else if ((lastBranchTarget > lastBranch) && (t1 < lastBranchTarget)) {
    t.x = lastBranchTarget;
  }

  p0[hook(5, prefetch_data_count)] = t;
  return prefetch_data_count + 1;
}

global unsigned int* generate_jit_code(global uint2* e, global uint2* p0, global unsigned int* p, unsigned int batch_size) {
  int prefetch_data_count;

  for (volatile int pass = 0; pass < 2; ++pass) {
    ulong registerLastChanged = 0;
    unsigned int registerWasChanged = 0;

    unsigned int scratchpadAvailableAt = 0;
    unsigned int scratchpadHighAvailableAt = 0;

    int lastBranchTarget = -1;
    int lastBranch = -1;

    ulong registerLastChangedAtBranchTarget = 0;
    unsigned int registerWasChangedAtBranchTarget = 0;

    unsigned int scratchpadAvailableAtBranchTarget = 0;
    unsigned int scratchpadHighAvailableAtBranchTarget = 0;

    prefetch_data_count = 0;

    for (unsigned int i = 0; i < 256; ++i) {
      if (pass == 0)
        e[hook(6, i)].x &= ~(0xf8u << 8);

      uint2 inst = e[hook(6, i)];
      unsigned int opcode = inst.x & 0xFF;
      const unsigned int dst = (inst.x >> 8) & 7;
      const unsigned int src = (inst.x >> 16) & 7;
      const unsigned int mod = inst.x >> 24;

      if (pass == 1) {
        if (inst.x & (0x20 << 8)) {
          lastBranchTarget = i;

          registerLastChangedAtBranchTarget = registerLastChanged;
          registerWasChangedAtBranchTarget = registerWasChanged;

          scratchpadAvailableAtBranchTarget = scratchpadAvailableAt;
          scratchpadHighAvailableAtBranchTarget = scratchpadHighAvailableAt;
        }

        if (inst.x & (0x40 << 8))
          lastBranch = i;
      }

      const unsigned int srcAvailableAt = (registerWasChanged & (1u << src)) ? (((registerLastChanged >> (src * 8)) & 0xFF) + 1) : 0;
      const unsigned int dstAvailableAt = (registerWasChanged & (1u << dst)) ? (((registerLastChanged >> (dst * 8)) & 0xFF) + 1) : 0;

      if (opcode < 16) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        continue;
      }
      opcode -= 16;

      if (opcode < 7) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        if (pass == 1)
          prefetch_data_count = jit_prefetch_read(p0, prefetch_data_count, i, src, dst, inst, srcAvailableAt, scratchpadAvailableAt, scratchpadHighAvailableAt, lastBranchTarget, lastBranch);
        continue;
      }
      opcode -= 7;

      if (opcode < 16) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        continue;
      }
      opcode -= 16;

      if (opcode < 7) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        if (pass == 1)
          prefetch_data_count = jit_prefetch_read(p0, prefetch_data_count, i, src, dst, inst, srcAvailableAt, scratchpadAvailableAt, scratchpadHighAvailableAt, lastBranchTarget, lastBranch);
        continue;
      }
      opcode -= 7;

      if (opcode < 16) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        continue;
      }
      opcode -= 16;

      if (opcode < 4) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        if (pass == 1)
          prefetch_data_count = jit_prefetch_read(p0, prefetch_data_count, i, src, dst, inst, srcAvailableAt, scratchpadAvailableAt, scratchpadHighAvailableAt, lastBranchTarget, lastBranch);
        continue;
      }
      opcode -= 4;

      if (opcode < 4) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        continue;
      }
      opcode -= 4;

      if (opcode < 1) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        if (pass == 1)
          prefetch_data_count = jit_prefetch_read(p0, prefetch_data_count, i, src, dst, inst, srcAvailableAt, scratchpadAvailableAt, scratchpadHighAvailableAt, lastBranchTarget, lastBranch);
        continue;
      }
      opcode -= 1;

      if (opcode < 4) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        continue;
      }
      opcode -= 4;

      if (opcode < 1) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        if (pass == 1)
          prefetch_data_count = jit_prefetch_read(p0, prefetch_data_count, i, src, dst, inst, srcAvailableAt, scratchpadAvailableAt, scratchpadHighAvailableAt, lastBranchTarget, lastBranch);
        continue;
      }
      opcode -= 1;

      if (opcode < 8) {
        if (inst.y & (inst.y - 1)) {
          registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
          registerWasChanged |= 1u << dst;
        }
        continue;
      }
      opcode -= 8;

      if (opcode < 2 + 15) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        continue;
      }
      opcode -= 2 + 15;

      if (opcode < 5) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        if (pass == 1)
          prefetch_data_count = jit_prefetch_read(p0, prefetch_data_count, i, src, dst, inst, srcAvailableAt, scratchpadAvailableAt, scratchpadHighAvailableAt, lastBranchTarget, lastBranch);
        continue;
      }
      opcode -= 5;

      if (opcode < 8 + 2) {
        registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
        registerWasChanged |= 1u << dst;

        continue;
      }
      opcode -= 8 + 2;

      if (opcode < 4) {
        if (src != dst) {
          registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
          registerLastChanged = (registerLastChanged & ~(0xFFul << (src * 8))) | ((ulong)(i) << (src * 8));
          registerWasChanged |= (1u << dst) | (1u << src);
        }
        continue;
      }
      opcode -= 4;

      if (opcode < 4 + 16) {
        continue;
      }
      opcode -= 4 + 16;

      if (opcode < 5) {
        if (pass == 1)
          prefetch_data_count = jit_prefetch_read(p0, prefetch_data_count, i, src, 0xFF, inst, srcAvailableAt, scratchpadAvailableAt, scratchpadHighAvailableAt, lastBranchTarget, lastBranch);
        continue;
      }
      opcode -= 5;

      if (opcode < 16) {
        continue;
      }
      opcode -= 16;

      if (opcode < 5) {
        if (pass == 1)
          prefetch_data_count = jit_prefetch_read(p0, prefetch_data_count, i, src, 0xFF, inst, srcAvailableAt, scratchpadAvailableAt, scratchpadHighAvailableAt, lastBranchTarget, lastBranch);
        continue;
      }
      opcode -= 5;

      if (opcode < 6 + 32) {
        continue;
      }
      opcode -= 6 + 32;

      if (opcode < 4) {
        if (pass == 1)
          prefetch_data_count = jit_prefetch_read(p0, prefetch_data_count, i, src, 0xFF, inst, srcAvailableAt, scratchpadAvailableAt, scratchpadHighAvailableAt, lastBranchTarget, lastBranch);
        continue;
      }
      opcode -= 4;

      if (opcode < 6) {
        continue;
      }
      opcode -= 6;

      if (opcode < 25) {
        if (pass == 0) {
          volatile unsigned int dstAvailableAt2 = dstAvailableAt;

          e[hook(6, dstAvailableAt2)].x |= (0x20 << 8);

          e[hook(6, i)].x |= (0x40 << 8);

          unsigned int t = i | (i << 8);
          t = t | (t << 16);
          registerLastChanged = t;
          registerLastChanged = registerLastChanged | (registerLastChanged << 32);
          registerWasChanged = 0xFF;

        } else {
          registerLastChanged = (registerLastChanged & ~(0xFFul << (dst * 8))) | ((ulong)(i) << (dst * 8));
          registerWasChanged |= 1u << dst;

          for (int reg = 0; reg < 8; ++reg) {
            const unsigned int availableAtBranchTarget = (registerWasChangedAtBranchTarget & (1u << reg)) ? (((registerLastChangedAtBranchTarget >> (reg * 8)) & 0xFF) + 1) : 0;
            const unsigned int availableAt = (registerWasChanged & (1u << reg)) ? (((registerLastChanged >> (reg * 8)) & 0xFF) + 1) : 0;
            if (availableAt != availableAtBranchTarget) {
              registerLastChanged = (registerLastChanged & ~(0xFFul << (reg * 8))) | ((ulong)(i) << (reg * 8));
              registerWasChanged |= 1u << reg;
            }
          }

          if (scratchpadAvailableAtBranchTarget != scratchpadAvailableAt)
            scratchpadAvailableAt = i + 1;

          if (scratchpadHighAvailableAtBranchTarget != scratchpadHighAvailableAt)
            scratchpadHighAvailableAt = i + 1;
        }
        continue;
      }
      opcode -= 25;

      if (opcode < 1) {
        continue;
      }
      opcode -= 1;

      if (opcode < 16) {
        if (pass == 0) {
          e[hook(6, i)].x = inst.x | (0x80 << 8);
        } else {
          scratchpadAvailableAt = i + 1;
          if ((mod >> 4) >= 14)
            scratchpadHighAvailableAt = i + 1;
        }
        continue;
      }
      opcode -= 16;
    }
  }

  unsigned int prev = p0[hook(5, 0)].x;
  for (int j = 1; j < prefetch_data_count; ++j) {
    uint2 cur = p0[hook(5, j)];
    if (cur.x >= prev) {
      prev = cur.x;
      continue;
    }

    int j1 = j - 1;
    do {
      p0[hook(5, j1 + 1)] = p0[hook(5, j1)];
      --j1;
    } while ((j1 >= 0) && (p0[hook(5, j1)].x >= cur.x));
    p0[hook(5, j1 + 1)] = cur;
  }
  p0[hook(5, prefetch_data_count)].x = 256;

  global int* prefecth_vgprs_stack = (global int*)(p0 + prefetch_data_count + 1);

  enum { num_prefetch_vgprs = 21 };

  for (int i = 0; i < num_prefetch_vgprs; ++i)
    prefecth_vgprs_stack[hook(7, i)] = 128 - 2 - i * 2;

  global int* prefetched_vgprs = prefecth_vgprs_stack + num_prefetch_vgprs;

  for (int i = 0; i < 256; ++i)
    prefetched_vgprs[hook(8, i)] = 0;

  int k = 0;
  uint2 prefetch_data = p0[hook(5, 0)];
  int mem_counter = 0;
  int s_waitcnt_value = 63;
  int num_prefetch_vgprs_available = num_prefetch_vgprs;

  global unsigned int* last_branch_target = p;

  const unsigned int size_limit = (10048 - 200) / sizeof(unsigned int);
  global unsigned int* start_p = p;

  for (int i = 0; i < 256; ++i) {
    const uint2 inst = e[hook(6, i)];

    if (inst.x & (0x20 << 8))
      last_branch_target = p;

    bool done = false;
    do {
      uint2 jit_inst;
      int jit_prefetch_vgpr_index;
      int jit_vmcnt;

      if (!done && (prefetch_data.x == i) && (num_prefetch_vgprs_available > 0)) {
        ++mem_counter;
        const int vgpr_id = prefecth_vgprs_stack[hook(7, --num_prefetch_vgprs_available)];
        prefetched_vgprs[hook(8, prefetch_data.y)] = vgpr_id | (mem_counter << 16);

        jit_inst = e[hook(6, prefetch_data.y)];
        jit_prefetch_vgpr_index = vgpr_id;
        jit_vmcnt = mem_counter;

        s_waitcnt_value = 63;

        ++k;
        prefetch_data = p0[hook(5, k)];
      } else {
        const int prefetched_vgprs_data = prefetched_vgprs[hook(8, i)];
        const int vgpr_id = prefetched_vgprs_data & 0xFFFF;
        const int prev_mem_counter = prefetched_vgprs_data >> 16;
        if (vgpr_id)
          prefecth_vgprs_stack[hook(7, num_prefetch_vgprs_available++)] = vgpr_id;

        if (inst.x & (0x80 << 8)) {
          ++mem_counter;
          s_waitcnt_value = 63;
        }

        const int vmcnt = mem_counter - prev_mem_counter;

        jit_inst = inst;
        jit_prefetch_vgpr_index = -vgpr_id;
        jit_vmcnt = (vmcnt < s_waitcnt_value) ? vmcnt : -1;

        if (vmcnt < s_waitcnt_value)
          s_waitcnt_value = vmcnt;

        done = true;
      }

      p = jit_emit_instruction(p, last_branch_target, jit_inst, jit_prefetch_vgpr_index, jit_vmcnt, batch_size);
      if (p - start_p > size_limit) {
        *(p++) = 0xbe801d0cu;
        return p;
      }
    } while (!done);
  }

  *(p++) = 0xbe801d0cu;
  return p;
}

__attribute__((reqd_work_group_size(64, 1, 1))) kernel void randomx_init(global ulong* entropy, global ulong* registers, global uint2* intermediate_programs, global unsigned int* programs, unsigned int batch_size) {
  const unsigned int global_index = get_global_id(0) / 32;
  const unsigned int sub = get_global_id(0) % 32;

  if (sub != 0)
    return;

  global uint2* e = (global uint2*)(entropy + global_index * ((128 + 256 * 8) / sizeof(ulong)) + (128 / sizeof(ulong)));
  global uint2* p0 = intermediate_programs + global_index * ((256 * 16) / sizeof(uint2));
  global unsigned int* p = programs + global_index * (10048 / sizeof(unsigned int));

  generate_jit_code(e, p0, p, batch_size);

  global ulong* R = registers + global_index * 32;
  entropy += global_index * ((128 + 256 * 8) / sizeof(ulong));

  R[hook(9, 0)] = 0;
  R[hook(9, 1)] = 0;
  R[hook(9, 2)] = 0;
  R[hook(9, 3)] = 0;
  R[hook(9, 4)] = 0;
  R[hook(9, 5)] = 0;
  R[hook(9, 6)] = 0;
  R[hook(9, 7)] = 0;

  global double* A = (global double*)(R + 24);
  A[hook(10, 0)] = getSmallPositiveFloatBits(entropy[hook(0, 0)]);
  A[hook(10, 1)] = getSmallPositiveFloatBits(entropy[hook(0, 1)]);
  A[hook(10, 2)] = getSmallPositiveFloatBits(entropy[hook(0, 2)]);
  A[hook(10, 3)] = getSmallPositiveFloatBits(entropy[hook(0, 3)]);
  A[hook(10, 4)] = getSmallPositiveFloatBits(entropy[hook(0, 4)]);
  A[hook(10, 5)] = getSmallPositiveFloatBits(entropy[hook(0, 5)]);
  A[hook(10, 6)] = getSmallPositiveFloatBits(entropy[hook(0, 6)]);
  A[hook(10, 7)] = getSmallPositiveFloatBits(entropy[hook(0, 7)]);

  ((global unsigned int*)(R + 16))[hook(11, 0)] = entropy[hook(0, 8)] & ((1U << 31) - 1) & ~(64U - 1);
  ((global unsigned int*)(R + 16))[hook(11, 1)] = entropy[hook(0, 10)];

  unsigned int addressRegisters = entropy[hook(0, 12)];
  ((global unsigned int*)(R + 17))[hook(12, 0)] = 0 + (addressRegisters & 1);
  addressRegisters >>= 1;
  ((global unsigned int*)(R + 17))[hook(12, 1)] = 2 + (addressRegisters & 1);
  addressRegisters >>= 1;
  ((global unsigned int*)(R + 17))[hook(12, 2)] = 4 + (addressRegisters & 1);
  addressRegisters >>= 1;
  ((global unsigned int*)(R + 17))[hook(12, 3)] = 6 + (addressRegisters & 1);

  ((global unsigned int*)(R + 19))[hook(13, 0)] = (entropy[hook(0, 13)] & 524287U) * 64U;

  R[hook(9, 20)] = getFloatMask(entropy[hook(0, 14)]);
  R[hook(9, 21)] = getFloatMask(entropy[hook(0, 15)]);
}