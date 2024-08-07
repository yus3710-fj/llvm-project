; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=slp-vectorizer -S -slp-revec -slp-max-reg-size=1024 -slp-threshold=-100 %s | FileCheck %s

define void @test1(ptr %a, ptr %b, ptr %c) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <16 x i32>, ptr [[A:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <16 x i32>, ptr [[B:%.*]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = add <16 x i32> [[TMP1]], [[TMP0]]
; CHECK-NEXT:    store <16 x i32> [[TMP2]], ptr [[C:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx3 = getelementptr inbounds i32, ptr %a, i64 4
  %arrayidx7 = getelementptr inbounds i32, ptr %a, i64 8
  %arrayidx11 = getelementptr inbounds i32, ptr %a, i64 12
  %0 = load <4 x i32>, ptr %a, align 4
  %1 = load <4 x i32>, ptr %arrayidx3, align 4
  %2 = load <4 x i32>, ptr %arrayidx7, align 4
  %3 = load <4 x i32>, ptr %arrayidx11, align 4
  %arrayidx19 = getelementptr inbounds i32, ptr %b, i64 4
  %arrayidx23 = getelementptr inbounds i32, ptr %b, i64 8
  %arrayidx27 = getelementptr inbounds i32, ptr %b, i64 12
  %4 = load <4 x i32>, ptr %b, align 4
  %5 = load <4 x i32>, ptr %arrayidx19, align 4
  %6 = load <4 x i32>, ptr %arrayidx23, align 4
  %7 = load <4 x i32>, ptr %arrayidx27, align 4
  %add.i = add <4 x i32> %4, %0
  %add.i63 = add <4 x i32> %5, %1
  %add.i64 = add <4 x i32> %6, %2
  %add.i65 = add <4 x i32> %7, %3
  %arrayidx36 = getelementptr inbounds i32, ptr %c, i64 4
  %arrayidx39 = getelementptr inbounds i32, ptr %c, i64 8
  %arrayidx42 = getelementptr inbounds i32, ptr %c, i64 12
  store <4 x i32> %add.i, ptr %c, align 4
  store <4 x i32> %add.i63, ptr %arrayidx36, align 4
  store <4 x i32> %add.i64, ptr %arrayidx39, align 4
  store <4 x i32> %add.i65, ptr %arrayidx42, align 4
  ret void
}

define void @test2(ptr %in, ptr %out) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <16 x i16>, ptr [[IN:%.*]], align 2
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16> [[TMP0]], <16 x i16> [[TMP0]])
; CHECK-NEXT:    store <16 x i16> [[TMP1]], ptr [[OUT:%.*]], align 2
; CHECK-NEXT:    ret void
;
entry:
  %0 = getelementptr i16, ptr %in, i64 8
  %1 = load <8 x i16>, ptr %in, align 2
  %2 = load <8 x i16>, ptr %0, align 2
  %3 = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %1, <8 x i16> %1)
  %4 = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %2, <8 x i16> %2)
  %5 = getelementptr i16, ptr %out, i64 8
  store <8 x i16> %3, ptr %out, align 2
  store <8 x i16> %4, ptr %5, align 2
  ret void
}
