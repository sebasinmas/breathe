import 'dart:async';
 
import 'package:breathe/domain/entities/example.dart';
 
abstract class ExampleRepository {
  Future<Example> getExample(String greeting);
}
