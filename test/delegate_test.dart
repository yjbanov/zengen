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

library zengen.delegate;

import 'transformation.dart';

main() {
  testTransformation('@Delegate() should create delagating methods',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1();
}
class B {
  @Delegate() A _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1();
}
class B {
  @Delegate() A _a;
  @generated dynamic m1() => _a.m1();
}
'''
      );

  testTransformation('@Delegate() should work when used on a getter',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1();
}
class B {
  @Delegate() A get _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1();
}
class B {
  @Delegate() A get _a;
  @generated dynamic m1() => _a.m1();
}
'''
      );

  testTransformation('@Delegate() should work setters and getters are mixed',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  get a;
  set b(v);
}
class B {
  @Delegate() A _a;
  set a(v) => null;
  get b => null;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  get a;
  set b(v);
}
class B {
  @Delegate() A _a;
  set a(v) => null;
  get b => null;
  @generated dynamic get a => _a.a;
  @generated set b(dynamic v) { _a.b = v; }
}
'''
      );

  testTransformation('@Delegate() should handle parameter',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1(a, int b);
}
class B {
  @Delegate() A _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1(a, int b);
}
class B {
  @Delegate() A _a;
  @generated dynamic m1(dynamic a, int b) => _a.m1(a, b);
}
'''
      );

  testTransformation('@Delegate() should handle optional positionnal parameter',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1(String a, [int b = 1, c]);
  m2([int b = 1, c]);
}
class B {
  @Delegate() A _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1(String a, [int b = 1, c]);
  m2([int b = 1, c]);
}
class B {
  @Delegate() A _a;
  @generated dynamic m1(String a, [int b, dynamic c]) => _a.m1(a, b, c);
  @generated dynamic m2([int b, dynamic c]) => _a.m2(b, c);
}
'''
      );

  testTransformation('@Delegate() should handle optional named parameter',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1(String a, {int b, c});
  m2({int b, c});
}
class B {
  @Delegate() A _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1(String a, {int b, c});
  m2({int b, c});
}
class B {
  @Delegate() A _a;
  @generated dynamic m1(String a, {int b, dynamic c}) => _a.m1(a, b: b, c: c);
  @generated dynamic m2({int b, dynamic c}) => _a.m2(b: b, c: c);
}
'''
      );

  testTransformation('@Delegate(exclude: const[#b]) should not create m1',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1(String a, {int b, c});
  m2({int b, c});
}
class B {
  @Delegate(exclude: const[#m1]) A _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1(String a, {int b, c});
  m2({int b, c});
}
class B {
  @Delegate(exclude: const[#m1]) A _a;
  @generated dynamic m2({int b, dynamic c}) => _a.m2(b: b, c: c);
}
'''
      );

  testTransformation('@Delegate() should handle simple generics',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<E> {
  E m1(E e);
}
class B<E> {
  @Delegate() A<E> _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<E> {
  E m1(E e);
}
class B<E> {
  @Delegate() A<E> _a;
  @generated E m1(E e) => _a.m1(e);
}
'''
      );

  testTransformation('@Delegate() should handle generics substitution',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<E> {
  E m1(E e);
}
class B {
  @Delegate() A<String> _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<E> {
  E m1(E e);
}
class B {
  @Delegate() A<String> _a;
  @generated String m1(String e) => _a.m1(e);
}
'''
      );

  testTransformation(
      '@Delegate() should handle generics substitution in generic types',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<E> {
  Iterable<E> m1(E e);
  Iterable<Iterable<E>> m2(Iterable<E> e);
  Iterable<Iterable<Iterable<E>>> m3(Iterable<Iterable<E>> e);
}
class B {
  @Delegate() A<String> _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<E> {
  Iterable<E> m1(E e);
  Iterable<Iterable<E>> m2(Iterable<E> e);
  Iterable<Iterable<Iterable<E>>> m3(Iterable<Iterable<E>> e);
}
class B {
  @Delegate() A<String> _a;
  @generated Iterable<String> m1(String e) => _a.m1(e);
  @generated Iterable<Iterable<String>> m2(Iterable<String> e) => _a.m2(e);
  @generated Iterable<Iterable<Iterable<String>>> m3(Iterable<Iterable<String>> e) => _a.m3(e);
}
'''
      );

  testTransformation('@Delegate() should handle generics functions',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<E> {
  m1(Iterable<E> f(Iterable<E> p1, E p2));
}
class B {
  @Delegate() A<String> _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<E> {
  m1(Iterable<E> f(Iterable<E> p1, E p2));
}
class B {
  @Delegate() A<String> _a;
  @generated dynamic m1(Iterable<String> f(Iterable<String> p1, String p2)) => _a.m1(f);
}
''',
      solo: false);

  testTransformation(
      '@Delegate() should handle generics with type specifications',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<S,T> {
  T m1(S e);
  S m2(T e);
}
class B<S> {
  @Delegate() A<S, int> _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<S,T> {
  T m1(S e);
  S m2(T e);
}
class B<S> {
  @Delegate() A<S, int> _a;
  @generated int m1(S e) => _a.m1(e);
  @generated S m2(int e) => _a.m2(e);
}
'''
      );

  testTransformation('@Delegate() should handle generics with bounds',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<S,T extends num> {
  T m1(S e);
  S m2(T e);
}
class B<S> {
  @Delegate() A<S, int> _a;
}
class C<T extends num> {
  @Delegate() A<String, T> _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<S,T extends num> {
  T m1(S e);
  S m2(T e);
}
class B<S> {
  @Delegate() A<S, int> _a;
  @generated int m1(S e) => _a.m1(e);
  @generated S m2(int e) => _a.m2(e);
}
class C<T extends num> {
  @Delegate() A<String, T> _a;
  @generated T m1(String e) => _a.m1(e);
  @generated String m2(T e) => _a.m2(e);
}
'''
      );

  testTransformation('@Delegate() should handle generics not specified',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<S,T extends int> {
  T m1(S e);
  S m2(T e);
}
class B<S> {
  @Delegate() A _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<S,T extends int> {
  T m1(S e);
  S m2(T e);
}
class B<S> {
  @Delegate() A _a;
  @generated int m1(dynamic e) => _a.m1(e);
  @generated dynamic m2(int e) => _a.m2(e);
}
'''
      );

  testTransformation('@Delegate() should handle operators',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  bool operator >(other);
  void operator []=(String key,value);
  operator [](key);
}
class B {
  @Delegate() A _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  bool operator >(other);
  void operator []=(String key,value);
  operator [](key);
}
class B {
  @Delegate() A _a;
  @generated bool operator >(dynamic other) => _a > other;
  @generated void operator []=(String key, dynamic value) { _a[key] = value; }
  @generated dynamic operator [](dynamic key) => _a[key];
}
'''
      );

  testTransformation('@Delegate() should avoid setter',
      r'''
import 'package:zengen/zengen.dart';
class A {
  int a;
  get b => null;
  set c(String value) {}
}
class B {
  @Delegate() A _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
class A {
  int a;
  get b => null;
  set c(String value) {}
}
class B {
  @Delegate() A _a;
  @generated int get a => _a.a;
  @generated void set a(int _a) { this._a.a = _a; }
  @generated dynamic get b => _a.b;
  @generated set c(String value) { _a.c = value; }
}
'''
      );

  testTransformation('@Delegate() should prefix by this. when naming conflicts',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1(_a);
}
class B {
  @Delegate() A _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1(_a);
}
class B {
  @Delegate() A _a;
  @generated dynamic m1(dynamic _a) => this._a.m1(_a);
}
'''
      );

  testTransformation('@Delegate() should add inherited members',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1();
}
abstract class M1 {
  m2();
}
abstract class M2 {
  m3();
}
abstract class I1 {
  m4();
}
abstract class I2<T> {
  T m5();
}
abstract class B extends A with M1, M2 implements I1, I2<int> {
  m6();
}
class C {
  @Delegate() B b;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1();
}
abstract class M1 {
  m2();
}
abstract class M2 {
  m3();
}
abstract class I1 {
  m4();
}
abstract class I2<T> {
  T m5();
}
abstract class B extends A with M1, M2 implements I1, I2<int> {
  m6();
}
class C {
  @Delegate() B b;
  @generated dynamic m6() => b.m6();
  @generated dynamic m4() => b.m4();
  @generated int m5() => b.m5();
  @generated dynamic m2() => b.m2();
  @generated dynamic m3() => b.m3();
  @generated dynamic m1() => b.m1();
}
'''
      );

  testTransformation('@Delegate() should not create private member',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1();
  _m2();
}
class B {
  @Delegate() A _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A {
  m1();
  _m2();
}
class B {
  @Delegate() A _a;
  @generated dynamic m1() => _a.m1();
}
'''
      );
}
