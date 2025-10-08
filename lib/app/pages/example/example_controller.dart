// lib/app/pages/example/example_controller.dart
import 'package:breathe/app/pages/example/example_presenter.dart';
import 'package:breathe/data/repositories/mock/data_mock_example_repository.dart';
import 'package:breathe/domain/entities/example.dart';
 
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
 
// Creamos una clase ExampleController extendiendo Controller de Clean Architecture
// Esta clase debe manejar toda la lógica de nuestra pantalla o componente.
class ExampleController extends Controller {
  // Definimos un objeto de clase ExamplePresenter
  final ExamplePresenter examplePresenter;
 
  // Definimos un objeto Example posiblemente nulo
  Example? example;
 
  // Creamos el constructor del Controlador
  // Como parámetro de entrada recibimos un repositorio, pueden ser uno o varios
  // incluidos otros tipos de objetos (los que sean necesario).
  // También inicializamos el presenter con el repositorio capturado
  ExampleController(DataMockExamplerepository dataMockExamplerepository)
    : examplePresenter = ExamplePresenter(dataMockExamplerepository),
      super();
 
  // Uno de los métodos de Controller, onInitState nos permite llamar o
  // inicializar elementos cuando se cree el estado de inicio de esta pantalla.
  @override
  void onInitState() {
    // Hacemos lo que está por defecto en la clase padre (Controller)
    super.onInitState();
    // Cuando pasen dos segundos, llamaremos al método getGreeting del
    // presenter. Acá no esperamos ningún dato.
    Future.delayed(Duration(seconds: 2), () {
      examplePresenter.getGreeting('Mundo');
    });
  }
 
  // en initListeners es donde implementamos las funciones vacías del presenter
  // como su nombre lo dice, implementamos o inicializamos los Listeners,
  // que estarán a la escuchande lo que mande el presenter (Observer).
  @override
  void initListeners() {
    // Cuando se complete, acá no hacemos nada
    examplePresenter.getExampleOnComplete = () {};
    // Cuando se gatille un error, no hacemos nada
    examplePresenter.getExampleOnError = (e) {};
    // Cuando obtengamos los datos, se los asignamos al objeto example y
    // refrescaremos la pantalla con refreshUI()
    examplePresenter.getExampleOnNext = (Example response) {
      example = response;
      refreshUI();
    };
  }
 
  // método para devolver el mensaje de greeting, sino devolvemos
  // un string vacío. para no causar un error ( hay formas más elegantes de
  // hacerlo).
  String returnedMsg() {
    if (example == null) {
      return '';
    } else {
      return example!.greeting as String;
    }
  }
}
