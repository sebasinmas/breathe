// lib/app/pages/example/example_presenter.dart
import 'package:breathe/domain/repositories/example_repository.dart';
import 'package:breathe/domain/usecases/get_example_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
 
// Clase que extiende de Presenter
// Presenter se encarga de manejar o preparar los datos para el controlador
class ExamplePresenter extends Presenter {
  // Creamos tres Funciones posiblemente vacías
  // Estas funcinoes son muy importantes ya que las
  // conectaremos deade el controlador.
  Function? getExampleOnComplete;
  Function? getExampleOnError;
  Function? getExampleOnNext;
 
  // Creamos un objeto privado del o los casos de uso que
  // utilizaremos en este presenter.
  final GetExampleUseCase _getExampleUseCase;
 
  // El constructor recibe un objeto de tipo ExampleRepository
  // debemos tener presente que este repository no es el esqueleto, sino
  // el repositorio de datos (mock, local o remote).
  // Luego Inicializamos el objeto privado _getExampleUseCase.
  ExamplePresenter(ExampleRepository exampleRepository)
      : _getExampleUseCase = GetExampleUseCase(exampleRepository);
 
  // Implementamos el dispose, cuando se descarte esta pantalla
  // limpiaremos la memoria que utiliza este presenter y desuscribiremos
  // el caso de uso.
  @override
  void dispose() {
    _getExampleUseCase.dispose();
  }
 
  // Método el cual llamaremos desde el controlador para ejecutar
  // nuestro caso de uso, como ven acá no recibimos ningpun dato
  // de eso se encargará el observador de cada caso de uso, y de cada
  // execute.
  void getGreeting(String greeting) {
    // Ejecutamos el caso de uso, este necesita dos parametros
    // el primero es el observador al cual le pasamos el presenter actual.
    // el segundo son los parámetros dene entrada del caso de uso.
    // Con _getExampleUseCaseObserver conectamos el Presenter con el Observer
    _getExampleUseCase.execute(
        _GetExampleUseCaseObserver(this), GetExampleUseCaseParams(greeting));
  }
}
 
// El observer se suscribe a un caso de uso y espera al stream de datos
// que este envía. Este stream puede contener datos, avisar si se terminó o
// si ocurrió algún error.
// El Observer debe implementar el Observer<T>, donde T es el objeto de retorno.
class _GetExampleUseCaseObserver
    implements Observer<GetExampleUseCaseResponse> {
  // Objeto de presenter
  final ExamplePresenter presenter;
  // Parametro de entrada con el presenter
  _GetExampleUseCaseObserver(this.presenter);
 
  // Debemos implementar onComplete, onError(error) y onNext(Response)
 
  // onComplete se gatilla automáticamente cuando el Stream se cierre.
  @override
  void onComplete() {
    // assert nos permite comprobar si tenemos implementada la
    // función que creamos en el Presenter en nuestro controlador.
    // si no la tenemos implementada en el controlador este dará error.
    assert(presenter.getExampleOnComplete != null);
 
    // Si todo va bien, gatillamos la función getExampleOnComplete del
    // presenter (es necesario terminarlo con ! para comprobar que no sea nulo).
    presenter.getExampleOnComplete!();
  }
 
  @override
  void onError(e) {
    assert(presenter.getExampleOnError != null);
 
    // Gatillamos el error, enviando la captura del error
    presenter.getExampleOnError!(e);
  }
 
  // onNext se ejecuta cuando recibimos datos :)
  // este response captura el objeto GetExampleUseCaseResponse.
  @override
  void onNext(response) {
    assert(presenter.getExampleOnNext != null);
 
    // Gatillamos la función getExampleOnNext enviando los datos
    // que debemos devolver en el parámetro de entrada.
    presenter.getExampleOnNext!(response!.example);
  }
}
