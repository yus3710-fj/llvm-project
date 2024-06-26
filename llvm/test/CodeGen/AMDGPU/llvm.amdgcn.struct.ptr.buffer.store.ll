;RUN: llc < %s -mtriple=amdgcn -mcpu=verde -verify-machineinstrs | FileCheck -check-prefix=VERDE %s
;RUN: llc < %s -mtriple=amdgcn -mcpu=tonga -verify-machineinstrs | FileCheck %s

;CHECK-LABEL: {{^}}buffer_store:
;CHECK-NOT: s_waitcnt
;CHECK: buffer_store_dwordx4 v[0:3], {{v[0-9]+}}, s[0:3], 0 idxen
;CHECK: buffer_store_dwordx4 v[4:7], {{v[0-9]+}}, s[0:3], 0 idxen glc
;CHECK: buffer_store_dwordx4 v[8:11], {{v[0-9]+}}, s[0:3], 0 idxen slc
define amdgpu_ps void @buffer_store(ptr addrspace(8) inreg, <4 x float>, <4 x float>, <4 x float>) {
main_body:
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float> %1, ptr addrspace(8) %0, i32 0, i32 0, i32 0, i32 0)
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float> %2, ptr addrspace(8) %0, i32 0, i32 0, i32 0, i32 1)
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float> %3, ptr addrspace(8) %0, i32 0, i32 0, i32 0, i32 2)
  ret void
}

;CHECK-LABEL: {{^}}buffer_store_immoffs:
;CHECK-NOT: s_waitcnt
;CHECK: buffer_store_dwordx4 v[0:3], {{v[0-9]+}}, s[0:3], 0 idxen offset:42
define amdgpu_ps void @buffer_store_immoffs(ptr addrspace(8) inreg, <4 x float>) {
main_body:
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float> %1, ptr addrspace(8) %0, i32 0, i32 42, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}buffer_store_idx:
;CHECK-NOT: s_waitcnt
;CHECK: buffer_store_dwordx4 v[0:3], v4, s[0:3], 0 idxen
define amdgpu_ps void @buffer_store_idx(ptr addrspace(8) inreg, <4 x float>, i32) {
main_body:
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float> %1, ptr addrspace(8) %0, i32 %2, i32 0, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}buffer_store_ofs:
;CHECK-NOT: s_waitcnt
;CHECK: buffer_store_dwordx4 v[0:3], v[4:5], s[0:3], 0 idxen offen
define amdgpu_ps void @buffer_store_ofs(ptr addrspace(8) inreg, <4 x float>, i32) {
main_body:
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float> %1, ptr addrspace(8) %0, i32 0, i32 %2, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}buffer_store_both:
;CHECK-NOT: s_waitcnt
;CHECK: buffer_store_dwordx4 v[0:3], v[4:5], s[0:3], 0 idxen offen
define amdgpu_ps void @buffer_store_both(ptr addrspace(8) inreg, <4 x float>, i32, i32) {
main_body:
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float> %1, ptr addrspace(8) %0, i32 %2, i32 %3, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}buffer_store_both_reversed:
;CHECK: v_mov_b32_e32 v6, v4
;CHECK-NOT: s_waitcnt
;CHECK: buffer_store_dwordx4 v[0:3], v[5:6], s[0:3], 0 idxen offen
define amdgpu_ps void @buffer_store_both_reversed(ptr addrspace(8) inreg, <4 x float>, i32, i32) {
main_body:
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float> %1, ptr addrspace(8) %0, i32 %3, i32 %2, i32 0, i32 0)
  ret void
}

; Ideally, the register allocator would avoid the wait here
;
;CHECK-LABEL: {{^}}buffer_store_wait:
;CHECK-NOT: s_waitcnt
;CHECK: buffer_store_dwordx4 v[0:3], v4, s[0:3], 0 idxen
;VERDE: s_waitcnt expcnt(0)
;CHECK: buffer_load_dwordx4 v[0:3], v5, s[0:3], 0 idxen
;CHECK: s_waitcnt vmcnt(0)
;CHECK: buffer_store_dwordx4 v[0:3], v6, s[0:3], 0 idxen
define amdgpu_ps void @buffer_store_wait(ptr addrspace(8) inreg, <4 x float>, i32, i32, i32) {
main_body:
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float> %1, ptr addrspace(8) %0, i32 %2, i32 0, i32 0, i32 0)
  %data = call <4 x float> @llvm.amdgcn.struct.ptr.buffer.load.v4f32(ptr addrspace(8) %0, i32 %3, i32 0, i32 0, i32 0)
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float> %data, ptr addrspace(8) %0, i32 %4, i32 0, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}buffer_store_x1:
;CHECK-NOT: s_waitcnt
;CHECK: buffer_store_dword v0, v1, s[0:3], 0 idxen
define amdgpu_ps void @buffer_store_x1(ptr addrspace(8) inreg %rsrc, float %data, i32 %index) {
main_body:
  call void @llvm.amdgcn.struct.ptr.buffer.store.f32(float %data, ptr addrspace(8) %rsrc, i32 %index, i32 0, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}buffer_store_x2:
;CHECK-NOT: s_waitcnt
;CHECK: buffer_store_dwordx2 v[0:1], v2, s[0:3], 0 idxen
define amdgpu_ps void @buffer_store_x2(ptr addrspace(8) inreg %rsrc, <2 x float> %data, i32 %index) #0 {
main_body:
  call void @llvm.amdgcn.struct.ptr.buffer.store.v2f32(<2 x float> %data, ptr addrspace(8) %rsrc, i32 %index, i32 0, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}buffer_store_int:
;CHECK-NOT: s_waitcnt
;CHECK: buffer_store_dwordx4 v[0:3], {{v[0-9]+}}, s[0:3], 0 idxen
;CHECK: buffer_store_dwordx2 v[4:5], {{v[0-9]+}}, s[0:3], 0 idxen glc
;CHECK: buffer_store_dword v6, {{v[0-9]+}}, s[0:3], 0 idxen slc
define amdgpu_ps void @buffer_store_int(ptr addrspace(8) inreg, <4 x i32>, <2 x i32>, i32) {
main_body:
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4i32(<4 x i32> %1, ptr addrspace(8) %0, i32 0, i32 0, i32 0, i32 0)
  call void @llvm.amdgcn.struct.ptr.buffer.store.v2i32(<2 x i32> %2, ptr addrspace(8) %0, i32 0, i32 0, i32 0, i32 1)
  call void @llvm.amdgcn.struct.ptr.buffer.store.i32(i32 %3, ptr addrspace(8) %0, i32 0, i32 0, i32 0, i32 2)
  ret void
}

;CHECK-LABEL: {{^}}struct_ptr_buffer_store_byte:
;CHECK-NEXT: %bb.
;CHECK-NEXT: v_cvt_u32_f32_e32 v{{[0-9]}}, v{{[0-9]}}
;CHECK-NEXT: buffer_store_byte v{{[0-9]}}, v{{[0-9]}}, s[0:3], 0 idxen
;CHECK-NEXT: s_endpgm
define amdgpu_ps void @struct_ptr_buffer_store_byte(ptr addrspace(8) inreg %rsrc, float %v1, i32 %index) {
main_body:
  %v2 = fptoui float %v1 to i32
  %v3 = trunc i32 %v2 to i8
  call void @llvm.amdgcn.struct.ptr.buffer.store.i8(i8 %v3, ptr addrspace(8) %rsrc, i32 %index, i32 0, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}struct_ptr_buffer_store_f16:
;CHECK-NEXT: %bb.
;CHECK-NEXT: v_cvt_f16_f32_e32 v{{[0-9]}}, v{{[0-9]}}
;CHECK-NEXT: buffer_store_short v{{[0-9]}}, v{{[0-9]}}, s[0:3], 0 idxen
;CHECK-NEXT: s_endpgm
define amdgpu_ps void @struct_ptr_buffer_store_f16(ptr addrspace(8) inreg %rsrc, float %v1, i32 %index) {
  %v2 = fptrunc float %v1 to half
  call void @llvm.amdgcn.struct.ptr.buffer.store.f16(half %v2, ptr addrspace(8) %rsrc, i32 %index, i32 0, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}struct_ptr_buffer_store_v2f16:
;CHECK-NEXT: %bb.
;CHECK: buffer_store_dword v0, {{v[0-9]+}}, s[0:3], 0 idxen
define amdgpu_ps void @struct_ptr_buffer_store_v2f16(ptr addrspace(8) inreg %rsrc, <2 x half> %v1, i32 %index) {
  call void @llvm.amdgcn.struct.ptr.buffer.store.v2f16(<2 x half> %v1, ptr addrspace(8) %rsrc, i32 %index, i32 0, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}struct_ptr_buffer_store_v4f16:
;CHECK-NEXT: %bb.
;CHECK: buffer_store_dwordx2 v[0:1], {{v[0-9]+}}, s[0:3], 0 idxen
define amdgpu_ps void @struct_ptr_buffer_store_v4f16(ptr addrspace(8) inreg %rsrc, <4 x half> %v1, i32 %index) {
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4f16(<4 x half> %v1, ptr addrspace(8) %rsrc, i32 %index, i32 0, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}struct_ptr_buffer_store_i16:
;CHECK-NEXT: %bb.
;CHECK-NEXT: v_cvt_u32_f32_e32 v{{[0-9]}}, v{{[0-9]}}
;CHECK-NEXT: buffer_store_short v{{[0-9]}}, v{{[0-9]}}, s[0:3], 0 idxen
;CHECK-NEXT: s_endpgm
define amdgpu_ps void @struct_ptr_buffer_store_i16(ptr addrspace(8) inreg %rsrc, float %v1, i32 %index) {
main_body:
  %v2 = fptoui float %v1 to i32
  %v3 = trunc i32 %v2 to i16
  call void @llvm.amdgcn.struct.ptr.buffer.store.i16(i16 %v3, ptr addrspace(8) %rsrc, i32 %index, i32 0, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}struct_ptr_buffer_store_vif16:
;CHECK-NEXT: %bb.
;CHECK: buffer_store_dword v0, {{v[0-9]+}}, s[0:3], 0 idxen
define amdgpu_ps void @struct_ptr_buffer_store_vif16(ptr addrspace(8) inreg %rsrc, <2 x i16> %v1, i32 %index) {
  call void @llvm.amdgcn.struct.ptr.buffer.store.v2i16(<2 x i16> %v1, ptr addrspace(8) %rsrc, i32 %index, i32 0, i32 0, i32 0)
  ret void
}

;CHECK-LABEL: {{^}}struct_ptr_buffer_store_v4i16:
;CHECK-NEXT: %bb.
;CHECK: buffer_store_dwordx2 v[0:1], {{v[0-9]+}}, s[0:3], 0 idxen
define amdgpu_ps void @struct_ptr_buffer_store_v4i16(ptr addrspace(8) inreg %rsrc, <4 x i16> %v1, i32 %index) {
  call void @llvm.amdgcn.struct.ptr.buffer.store.v4i16(<4 x i16> %v1, ptr addrspace(8) %rsrc, i32 %index, i32 0, i32 0, i32 0)
  ret void
}

declare void @llvm.amdgcn.struct.ptr.buffer.store.f32(float, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.v2f32(<2 x float>, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.v4f32(<4 x float>, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.i32(i32, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.v2i32(<2 x i32>, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.v4i32(<4 x i32>, ptr addrspace(8), i32, i32, i32, i32) #0
declare <4 x float> @llvm.amdgcn.struct.ptr.buffer.load.v4f32(ptr addrspace(8), i32, i32, i32, i32) #1
declare void @llvm.amdgcn.struct.ptr.buffer.store.i8(i8, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.i16(i16, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.v2i16(<2 x i16>, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.v4i16(<4 x i16>, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.f16(half, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.v2f16(<2 x half>, ptr addrspace(8), i32, i32, i32, i32) #0
declare void @llvm.amdgcn.struct.ptr.buffer.store.v4f16(<4 x half>, ptr addrspace(8), i32, i32, i32, i32) #0


attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }
