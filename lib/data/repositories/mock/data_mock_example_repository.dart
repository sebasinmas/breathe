import 'dart:async';
 
import 'package:breathe/domain/entities/example.dart';
import 'package:breathe/domain/repositories/example_repository.dart';
import 'package:logging/logging.dart';
 
// Creamos una clase que implemente el esqueleto de ExampleRepository
// (clase abstracta), el archivo que se encuentra en
// lib/domain/repositories/example_repository.dart.
// Por lo que necesitamos agregarle cuerpo a getExample
class DataMockExamplerepository implements ExampleRepository {
 
  Logger _logger;
 
  // Esta clase utiliza el patrón singleton, por lo que crearemos
  // un constructor con nombre privado llamado _internal, el cual
  // tiene un parámetro de asignación para asignar un nuevo objeto
  // Logger...
  DataMockExamplerepository._internal()
      : _logger = Logger('DataMockExampleRepository');
 
  // Luego creamos un objeto del mismo tipo de la clase,
  // llamado _instance, que se creará a partir del constructor con nombre
  // antes creado.
  static final DataMockExamplerepository _instance =
  DataMockExamplerepository._internal();
 
  // Finalmente renombramos el contructor principal por la instancia ya
  // creada con el método factory (no siempre crea el objeto nuevo, solo
  // utilizamos el ya existente).
  factory DataMockExamplerepository() => _instance;
 
  // Implementamos el método getExample, el cual sólo retorna un objeto
  // Example, con el atributo greeting obtenido del parámetro de entrada.
  @override
  Future<Example> getExample(String greeting) async {
    try {
      _logger.finest('DataMockExampleRepository successful');
      return Example(greeting: greeting);
    } catch (error) {
      _logger.warning('DataMockExampleRepository.', error);
      rethrow;
    }
  }
}