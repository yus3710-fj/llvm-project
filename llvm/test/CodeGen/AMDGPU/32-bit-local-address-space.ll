; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -mtriple=amdgcn -mcpu=bonaire < %s | FileCheck -check-prefixes=SI,FUNC,GFX7 %s
; RUN: llc -mtriple=amdgcn -mcpu=tonga -mattr=-flat-for-global < %s | FileCheck -check-prefixes=SI,FUNC,GFX8 %s

; On Southern Islands GPUs the local address space(3) uses 32-bit pointers and
; the global address space(1) uses 64-bit pointers.  These tests check to make sure
; the correct pointer size is used for the local address space.

; The e{{32|64}} suffix on the instructions refers to the encoding size and not
; the size of the operands.  The operand size is denoted in the instruction name.
; Instructions with B32, U32, and I32 in their name take 32-bit operands, while
; instructions with B64, U64, and I64 take 64-bit operands.

define amdgpu_kernel void @local_address_load(ptr addrspace(1) %out, ptr addrspace(3) %in) {
; GFX7-LABEL: local_address_load:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dword s2, s[4:5], 0xb
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s2
; GFX7-NEXT:    ds_read_b32 v0, v0
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: local_address_load:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_load_dword s2, s[4:5], 0x2c
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x24
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    s_mov_b32 s3, 0xf000
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    ds_read_b32 v0, v0
; GFX8-NEXT:    s_mov_b32 s2, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX8-NEXT:    s_endpgm
entry:
  %0 = load i32, ptr addrspace(3) %in
  store i32 %0, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @local_address_gep(ptr addrspace(1) %out, ptr addrspace(3) %in, i32 %offset) {
; GFX7-LABEL: local_address_gep:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x9
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_lshl_b32 s3, s3, 2
; GFX7-NEXT:    s_add_i32 s2, s2, s3
; GFX7-NEXT:    v_mov_b32_e32 v0, s2
; GFX7-NEXT:    ds_read_b32 v0, v0
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: local_address_gep:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x24
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_lshl_b32 s3, s3, 2
; GFX8-NEXT:    s_add_i32 s2, s2, s3
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    ds_read_b32 v0, v0
; GFX8-NEXT:    s_mov_b32 s3, 0xf000
; GFX8-NEXT:    s_mov_b32 s2, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX8-NEXT:    s_endpgm
entry:
  %0 = getelementptr i32, ptr addrspace(3) %in, i32 %offset
  %1 = load i32, ptr addrspace(3) %0
  store i32 %1, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @local_address_gep_const_offset(ptr addrspace(1) %out, ptr addrspace(3) %in) {
; GFX7-LABEL: local_address_gep_const_offset:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dword s2, s[4:5], 0xb
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s2
; GFX7-NEXT:    ds_read_b32 v0, v0 offset:4
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: local_address_gep_const_offset:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_load_dword s2, s[4:5], 0x2c
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x24
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    s_mov_b32 s3, 0xf000
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    ds_read_b32 v0, v0 offset:4
; GFX8-NEXT:    s_mov_b32 s2, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX8-NEXT:    s_endpgm
entry:
  %0 = getelementptr i32, ptr addrspace(3) %in, i32 1
  %1 = load i32, ptr addrspace(3) %0
  store i32 %1, ptr addrspace(1) %out
  ret void
}

; Offset too large, can't fold into 16-bit immediate offset.
define amdgpu_kernel void @local_address_gep_large_const_offset(ptr addrspace(1) %out, ptr addrspace(3) %in) {
; GFX7-LABEL: local_address_gep_large_const_offset:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dword s2, s[4:5], 0xb
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_add_i32 s2, s2, 0x10004
; GFX7-NEXT:    v_mov_b32_e32 v0, s2
; GFX7-NEXT:    ds_read_b32 v0, v0
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: local_address_gep_large_const_offset:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_load_dword s2, s[4:5], 0x2c
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x24
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    s_mov_b32 s3, 0xf000
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_add_i32 s2, s2, 0x10004
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    ds_read_b32 v0, v0
; GFX8-NEXT:    s_mov_b32 s2, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX8-NEXT:    s_endpgm
entry:
  %0 = getelementptr i32, ptr addrspace(3) %in, i32 16385
  %1 = load i32, ptr addrspace(3) %0
  store i32 %1, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @null_32bit_lds_ptr(ptr addrspace(1) %out, ptr addrspace(3) %lds) nounwind {
; GFX7-LABEL: null_32bit_lds_ptr:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dword s6, s[4:5], 0xb
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; GFX7-NEXT:    s_movk_i32 s4, 0x7b
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_cmp_lg_u32 s6, 0
; GFX7-NEXT:    s_cselect_b32 s4, s4, 0x1c8
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: null_32bit_lds_ptr:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dword s6, s[4:5], 0x2c
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x24
; GFX8-NEXT:    s_movk_i32 s4, 0x7b
; GFX8-NEXT:    s_mov_b32 s3, 0xf000
; GFX8-NEXT:    s_mov_b32 s2, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_cmp_lg_u32 s6, 0
; GFX8-NEXT:    s_cselect_b32 s4, s4, 0x1c8
; GFX8-NEXT:    v_mov_b32_e32 v0, s4
; GFX8-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX8-NEXT:    s_endpgm
  %cmp = icmp ne ptr addrspace(3) %lds, null
  %x = select i1 %cmp, i32 123, i32 456
  store i32 %x, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @mul_32bit_ptr(ptr addrspace(1) %out, ptr addrspace(3) %lds, i32 %tid) {
; GFX7-LABEL: mul_32bit_ptr:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x9
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_mul_i32 s3, s3, 12
; GFX7-NEXT:    s_add_i32 s2, s2, s3
; GFX7-NEXT:    v_mov_b32_e32 v0, s2
; GFX7-NEXT:    ds_read_b32 v0, v0
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: mul_32bit_ptr:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x24
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_mul_i32 s3, s3, 12
; GFX8-NEXT:    s_add_i32 s2, s2, s3
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    ds_read_b32 v0, v0
; GFX8-NEXT:    s_mov_b32 s3, 0xf000
; GFX8-NEXT:    s_mov_b32 s2, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX8-NEXT:    s_endpgm
  %ptr = getelementptr [3 x float], ptr addrspace(3) %lds, i32 %tid, i32 0
  %val = load float, ptr addrspace(3) %ptr
  store float %val, ptr addrspace(1) %out
  ret void
}

@g_lds = addrspace(3) global float poison, align 4

define amdgpu_kernel void @infer_ptr_alignment_global_offset(ptr addrspace(1) %out, i32 %tid) {
; GFX7-LABEL: infer_ptr_alignment_global_offset:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    v_mov_b32_e32 v0, 0
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; GFX7-NEXT:    ds_read_b32 v0, v0
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: infer_ptr_alignment_global_offset:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, 0
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x24
; GFX8-NEXT:    ds_read_b32 v0, v0
; GFX8-NEXT:    s_mov_b32 s3, 0xf000
; GFX8-NEXT:    s_mov_b32 s2, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX8-NEXT:    s_endpgm
  %val = load float, ptr addrspace(3) @g_lds
  store float %val, ptr addrspace(1) %out
  ret void
}

@ptr = addrspace(3) global ptr addrspace(3) poison
@dst = addrspace(3) global [16383 x i32] poison

define amdgpu_kernel void @global_ptr() nounwind {
; SI-LABEL: global_ptr:
; SI:       ; %bb.0:
; SI-NEXT:    v_mov_b32_e32 v0, 64
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_mov_b32 m0, -1
; SI-NEXT:    ds_write_b32 v1, v0 offset:65532
; SI-NEXT:    s_endpgm
  store ptr addrspace(3) getelementptr ([16383 x i32], ptr addrspace(3) @dst, i32 0, i32 16), ptr addrspace(3) @ptr
  ret void
}

define amdgpu_kernel void @local_address_store(ptr addrspace(3) %out, i32 %val) {
; GFX7-LABEL: local_address_store:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    ds_write_b32 v0, v1
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: local_address_store:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x24
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    ds_write_b32 v0, v1
; GFX8-NEXT:    s_endpgm
  store i32 %val, ptr addrspace(3) %out
  ret void
}

define amdgpu_kernel void @local_address_gep_store(ptr addrspace(3) %out, i32, i32 %val, i32 %offset) {
; GFX7-LABEL: local_address_gep_store:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0xb
; GFX7-NEXT:    s_load_dword s2, s[4:5], 0x9
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_lshl_b32 s1, s1, 2
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    s_add_i32 s0, s2, s1
; GFX7-NEXT:    v_mov_b32_e32 v1, s0
; GFX7-NEXT:    ds_write_b32 v1, v0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: local_address_gep_store:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x2c
; GFX8-NEXT:    s_load_dword s2, s[4:5], 0x24
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_lshl_b32 s1, s1, 2
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    s_add_i32 s0, s2, s1
; GFX8-NEXT:    v_mov_b32_e32 v1, s0
; GFX8-NEXT:    ds_write_b32 v1, v0
; GFX8-NEXT:    s_endpgm
  %gep = getelementptr i32, ptr addrspace(3) %out, i32 %offset
  store i32 %val, ptr addrspace(3) %gep, align 4
  ret void
}

define amdgpu_kernel void @local_address_gep_const_offset_store(ptr addrspace(3) %out, i32 %val) {
; GFX7-LABEL: local_address_gep_const_offset_store:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    ds_write_b32 v0, v1 offset:4
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: local_address_gep_const_offset_store:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x24
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    ds_write_b32 v0, v1 offset:4
; GFX8-NEXT:    s_endpgm
  %gep = getelementptr i32, ptr addrspace(3) %out, i32 1
  store i32 %val, ptr addrspace(3) %gep, align 4
  ret void
}

; Offset too large, can't fold into 16-bit immediate offset.
define amdgpu_kernel void @local_address_gep_large_const_offset_store(ptr addrspace(3) %out, i32 %val) {
; GFX7-LABEL: local_address_gep_large_const_offset_store:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_add_i32 s0, s0, 0x10004
; GFX7-NEXT:    v_mov_b32_e32 v0, s1
; GFX7-NEXT:    v_mov_b32_e32 v1, s0
; GFX7-NEXT:    ds_write_b32 v1, v0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: local_address_gep_large_const_offset_store:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x24
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_add_i32 s0, s0, 0x10004
; GFX8-NEXT:    v_mov_b32_e32 v0, s1
; GFX8-NEXT:    v_mov_b32_e32 v1, s0
; GFX8-NEXT:    ds_write_b32 v1, v0
; GFX8-NEXT:    s_endpgm
  %gep = getelementptr i32, ptr addrspace(3) %out, i32 16385
  store i32 %val, ptr addrspace(3) %gep, align 4
  ret void
}
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; FUNC: {{.*}}
