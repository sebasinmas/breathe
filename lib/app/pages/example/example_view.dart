// lib/app/pages/example/example_view.dart
import 'package:breathe/app/pages/example/example_controller.dart';
import 'package:breathe/data/repositories/mock/data_mock_example_repository.dart';
import 'package:flutter/material.dart';
 
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
 
// Creamos una vista (clase) que extiende de CleanView (clean architecture)
// Es similar al View normal con el StatefulWidget
class ExamplePage extends CleanView {
  // Constructor
  const ExamplePage({super.key});
 
  // Creamos un estado de pantalla
  @override
  _ExamplePageState createState() => _ExamplePageState();
}
 
// Creamos una clase privada que extiende de CleanViewState (similar a State)
// aunque en este caso, además de darle el tipo de la pantalla (ExamplePage),
// debemos incluir el controlador que estará a cargo de la pantalla.
class _ExamplePageState extends CleanViewState<ExamplePage, ExampleController> {
  // Constructor de la clase, en este caso sin parámetros de entrada
  // pero inicializamos a la clase padre (CleanVIewState), con el controlador
  // requerido y su repositorio (véase el constructor de ExampleController en
  // lib/app/pages/example/example_controller.dart
  _ExamplePageState() : super(ExampleController(DataMockExamplerepository()));
 
  // Cambiamos el override Build de State por 'get view' de CleanViewState
  @override
  Widget get view {
    // Retornamos un Widget Scaffold
    return Scaffold(
      // Utilizamos la key global
      key: globalKey,
      // Aplicamos el appbar normal
      appBar: AppBar(title: const Text('Example page')),
      // Implementamos el body con un center, acá ocurre algo interesante...
      body: Center(
        // En el child, utilizamos ControlledWidgetBuild, que permite
        // enviar y recibir datos al controlador. Especificamos el
        // controlador, y en el builder se le pasa el contexto y el controlador
        // inicializado.
        child: ControlledWidgetBuilder<ExampleController>(
          builder: (context, controller) {
            // A cada refresh devolvemos un Text. Conectamos el método
            // returnedMsg desde el controlador.
            return Text('Hola ${controller.returnedMsg()}');
          },
        ),
      ),
    );
  }
}
