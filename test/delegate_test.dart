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

  testTransformation('@Delegate() should handle generics 1',
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

  testTransformation('@Delegate() should handle generics 2',
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
abstract class A<S,T extends int> {
  T m1(S e);
  S m2(T e);
}
class B<S> {
  @Delegate() A<S, int> _a;
}
''',
      r'''
import 'package:zengen/zengen.dart';
abstract class A<S,T extends int> {
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
}
