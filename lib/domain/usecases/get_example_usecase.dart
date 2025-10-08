import 'dart:async';
 
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:logging/logging.dart';
import 'package:breathe/domain/entities/example.dart';
import 'package:breathe/domain/repositories/example_repository.dart';
 
// Creamos una clase que extiende de UseCase (Caso de Uso)
// UseCase utiliza dos Un Genérico y un parámetro de entrada ( <T,Params>)
// Por lo que GetExampleUseCaseResponse es el tipo de respuesta
// y GetExampleUseCaseParams son los parámetros de entrada (y puede ser
// void cuando no es necesario pasarle parámetros al caso de uso)
class GetExampleUseCase
    extends UseCase<GetExampleUseCaseResponse, GetExampleUseCaseParams> {
  // Definimos un objeto (Repositorio) (Recordar que si bien incluimos el
  // repositorio esqueleto, acá deberíamos recibir el repositorio mock, o local
  // o remoto.
  final ExampleRepository exampleRepository;
 
  // Creamos el objeto Logger ( porque print puede causarnos problemas de
  // seguridad)
  
  final Logger _logger;
 
  //Constructor
  GetExampleUseCase(this.exampleRepository)
    : _logger = Logger('GetExampleUseCase');
 
  // Hacemos override al Stream de datos, que se suscriba al repositorio
  // que queremos.
  // Devuelve un Futuro, por lo que es asíncrono
  @override
  Future<Stream<GetExampleUseCaseResponse?>> buildUseCaseStream(
    GetExampleUseCaseParams? params,
  ) async {
    // Creamos un controlador de Stream encapsulando la respuesta que
    // deberíamos devolver.
    final controller = StreamController<GetExampleUseCaseResponse>();
 
    // Utilizamos un try/catch para capturar errores
    try {
      // Esperamos al método del repositorio
      final Example example = await exampleRepository.getExample(
        params!.greeting,
      );
      // Una vez obtenidos los datos, se lo enviamos al Stream (que fluya desde
      // donde se solicitó).
      controller.add(GetExampleUseCaseResponse(example));
 
      // imprimimos el Log
      _logger.finest('GetExampleUseCase successful.');
 
      // Cerramos el controller del Stream, no necesitamos agregar más
      // elementos.
      controller.close();
    } catch (e) {
      _logger.severe('GetExampleUseCase unsuccessful.');
 
      // Agregamos el error al stream, para avisar que algo falló a quien
      // llama a este UseCase.
      controller.addError(e);
    }
 
    // Retornamos el stream... terminamos.
    return controller.stream;
  }
}
 
// Objeto que recibimos como parámetros
class GetExampleUseCaseParams {
  final String greeting;
  GetExampleUseCaseParams(this.greeting);
}
 
// Objeto de respuesta
class GetExampleUseCaseResponse {
  final Example example;
  GetExampleUseCaseResponse(this.example);
}