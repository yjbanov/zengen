// Copyright (c) 2014, Alexandre Ardhuin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library zengen.implementation;

import 'transformation.dart';

main() {
  testTransformation('@Implementation() should add basic method',
      r'''
import 'package:zengen/zengen.dart';
class A {
  m1();
  @Implementation() _noSuchMethod(i) => print(i);
}
''',
      r'''
import 'package:zengen/zengen.dart';
class A {
  @generated dynamic m1() => _noSuchMethod(new StringInvocation('m1', isMethod: true));
  @Implementation() _noSuchMethod(i) => print(i);
}
'''
      );

  testTransformation('@Implementation() should handle getter and setter',
      r'''
import 'package:zengen/zengen.dart';
class A {
  String get g;
  void set s(String s);
  @Implementation() _noSuchMethod(i) => print(i);
}
''',
      r'''
import 'package:zengen/zengen.dart';
class A {
  @generated String get g => _noSuchMethod(new StringInvocation('g', isGetter: true));
  @generated void set s(String s) { _noSuchMethod(new StringInvocation('s', isSetter: true, positionalArguments: [s])); }
  @Implementation() _noSuchMethod(i) => print(i);
}
'''
      );

  testTransformation('@Implementation() should handle method parameters',
      r'''
import 'package:zengen/zengen.dart';
class A {
  m1(String p1, p2, int p3, void f(String fp1, fp2));
  @Implementation() _noSuchMethod(i) => print(i);
}
''',
      r'''
import 'package:zengen/zengen.dart';
class A {
  @generated dynamic m1(String p1, dynamic p2, int p3, void f(String fp1, dynamic fp2)) => _noSuchMethod(new StringInvocation('m1', isMethod: true, positionalArguments: [p1, p2, p3, f]));
  @Implementation() _noSuchMethod(i) => print(i);
}
'''
      );

  testTransformation(
      '@Implementation() should handle optional positonal parameters',
      r'''
import 'package:zengen/zengen.dart';
class A {
  m1(String p1, [p2, int p3, void f(String fp1, fp2)]);
  @Implementation() _noSuchMethod(i) => print(i);
}
''',
      r'''
import 'package:zengen/zengen.dart';
class A {
  @generated dynamic m1(String p1, [dynamic p2, int p3, void f(String fp1, dynamic fp2)]) => _noSuchMethod(new StringInvocation('m1', isMethod: true, positionalArguments: [p1, p2, p3, f]));
  @Implementation() _noSuchMethod(i) => print(i);
}
'''
      );

  testTransformation(
      '@Implementation() should handle optional named parameters',
      r'''
import 'package:zengen/zengen.dart';
class A {
  m1(String p1, {p2, int p3, void f(String fp1, fp2)});
  @Implementation() _noSuchMethod(i) => print(i);
}
''',
      r'''
import 'package:zengen/zengen.dart';
class A {
  @generated dynamic m1(String p1, {dynamic p2, int p3, void f(String fp1, dynamic fp2)}) => _noSuchMethod(new StringInvocation('m1', isMethod: true, positionalArguments: [p1], namedArguments: {'p2': p2, 'p3': p3, 'f': f}));
  @Implementation() _noSuchMethod(i) => print(i);
}
'''
      );

  testTransformation(
      '@Implementation() should handle optional positonal parameters with default values',
      r'''
import 'package:zengen/zengen.dart';
class A {
  m1(String p1, [p2 = "t", int p3 = 1]);
  @Implementation() _noSuchMethod(i) => print(i);
}
''',
      r'''
import 'package:zengen/zengen.dart';
class A {
  @generated dynamic m1(String p1, [dynamic p2 = "t", int p3 = 1]) => _noSuchMethod(new StringInvocation('m1', isMethod: true, positionalArguments: [p1, p2, p3]));
  @Implementation() _noSuchMethod(i) => print(i);
}
'''
      );

  testTransformation(
      '@Implementation() should handle optional named parameters with default values',
      r'''
import 'package:zengen/zengen.dart';
class A {
  m1(String p1, {p2: "t", int p3: 1});
  @Implementation() _noSuchMethod(i) => print(i);
}
''',
      r'''
import 'package:zengen/zengen.dart';
class A {
  @generated dynamic m1(String p1, {dynamic p2: "t", int p3: 1}) => _noSuchMethod(new StringInvocation('m1', isMethod: true, positionalArguments: [p1], namedArguments: {'p2': p2, 'p3': p3}));
  @Implementation() _noSuchMethod(i) => print(i);
}
'''
      );

  testTransformation('@Implementation() should go through class hierarchy',
      r'''
import 'package:zengen/zengen.dart';
abstract class I1 {
  int f1;
  i1();
}
abstract class I2 {
  i2();
}
abstract class M1 {
  m1();
}
abstract class M2 {
  m2();
  a2();
}
abstract class M3<T> {
  m3(T t);
}
abstract class A {
  a1();
  a2() => null;
}
abstract class B extends A with M1 implements I1 {
  b1();
}
class C extends B with M2, M3<int> implements I2 {
  c1();
  @Implementation() _noSuchMethod(i) => print(i);
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class I1 {
  int f1;
  i1();
}
abstract class I2 {
  i2();
}
abstract class M1 {
  m1();
}
abstract class M2 {
  m2();
  a2();
}
abstract class M3<T> {
  m3(T t);
}
abstract class A {
  a1();
  a2() => null;
}
abstract class B extends A with M1 implements I1 {
  b1();
}
class C extends B with M2, M3<int> implements I2 {
  @generated dynamic c1() => _noSuchMethod(new StringInvocation('c1', isMethod: true));
  @Implementation() _noSuchMethod(i) => print(i);
  @generated dynamic b1() => _noSuchMethod(new StringInvocation('b1', isMethod: true));
  @generated dynamic a1() => _noSuchMethod(new StringInvocation('a1', isMethod: true));
  @generated dynamic m1() => _noSuchMethod(new StringInvocation('m1', isMethod: true));
  @generated int get f1 => _noSuchMethod(new StringInvocation('f1', isGetter: true));
  @generated void set f1(int _f1) { _noSuchMethod(new StringInvocation('f1', isSetter: true, positionalArguments: [_f1])); }
  @generated dynamic i1() => _noSuchMethod(new StringInvocation('i1', isMethod: true));
  @generated dynamic m2() => _noSuchMethod(new StringInvocation('m2', isMethod: true));
  @generated dynamic m3(int t) => _noSuchMethod(new StringInvocation('m3', isMethod: true, positionalArguments: [t]));
  @generated dynamic i2() => _noSuchMethod(new StringInvocation('i2', isMethod: true));
}
'''
      );

  testTransformation('@Implementation() should work with generics',
      r'''
import 'package:zengen/zengen.dart';
abstract class I1<T> {
  T i1(T t);
}
abstract class I2<T1 extends num, T2> {
  T1 i2(T2 t);
}
class A<T extends num> implements I1<int>, I2<T, String> {
  T c1();
  @Implementation() _noSuchMethod(i) => print(i);
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class I1<T> {
  T i1(T t);
}
abstract class I2<T1 extends num, T2> {
  T1 i2(T2 t);
}
class A<T extends num> implements I1<int>, I2<T, String> {
  @generated T c1() => _noSuchMethod(new StringInvocation('c1', isMethod: true));
  @Implementation() _noSuchMethod(i) => print(i);
  @generated int i1(int t) => _noSuchMethod(new StringInvocation('i1', isMethod: true, positionalArguments: [t]));
  @generated T i2(String t) => _noSuchMethod(new StringInvocation('i2', isMethod: true, positionalArguments: [t]));
}
'''
      );
}
