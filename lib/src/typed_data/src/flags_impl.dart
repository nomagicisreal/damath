part of '../typed_data.dart';

///
///
/// [_MixinFlagsOperate8], [_MixinFlagsOperate16], [_MixinFlagsOperate32], [_MixinFlagsOperate64]
/// [_MixinFlagsValueInsert]
///
///

///
///
///
///
mixin _MixinFlagsOperate8 implements _FlagsOperator {
  @override
  int get _shift => TypedIntList.shift8;

  @override
  int get _mask => TypedIntList.mask8;

  @override
  int get _sizeEach => TypedIntList.sizeEach8;
}

mixin _MixinFlagsOperate16 implements _FlagsOperator {
  @override
  int get _shift => TypedIntList.shift16;

  @override
  int get _mask => TypedIntList.mask16;

  @override
  int get _sizeEach => TypedIntList.sizeEach16;
}

mixin _MixinFlagsOperate32 implements _FlagsOperator {
  @override
  int get _shift => TypedIntList.shift32;

  @override
  int get _mask => TypedIntList.mask32;

  @override
  int get _sizeEach => TypedIntList.sizeEach32;
}

mixin _MixinFlagsOperate64 implements _FlagsOperator {
  @override
  int get _shift => TypedIntList.shift64;

  @override
  int get _mask => TypedIntList.mask64;

  @override
  int get _sizeEach => TypedIntList.sizeEach64;
}

