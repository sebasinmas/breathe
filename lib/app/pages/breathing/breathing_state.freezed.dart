// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breathing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BreathingState {
  /// Estado actual del ejercicio
  BreathingStatus get status => throw _privateConstructorUsedError;

  /// Lista de ejercicios disponibles
  List<BreathingExercise> get exercises => throw _privateConstructorUsedError;

  /// Ejercicio seleccionado actualmente
  BreathingExercise? get selectedExercise => throw _privateConstructorUsedError;

  /// Índice del paso actual en el ejercicio
  int get currentStepIndex => throw _privateConstructorUsedError;

  /// Progreso del paso actual (0.0 a 1.0)
  double get stepProgress => throw _privateConstructorUsedError;

  /// Mensaje de error si existe
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of BreathingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreathingStateCopyWith<BreathingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreathingStateCopyWith<$Res> {
  factory $BreathingStateCopyWith(
    BreathingState value,
    $Res Function(BreathingState) then,
  ) = _$BreathingStateCopyWithImpl<$Res, BreathingState>;
  @useResult
  $Res call({
    BreathingStatus status,
    List<BreathingExercise> exercises,
    BreathingExercise? selectedExercise,
    int currentStepIndex,
    double stepProgress,
    String? errorMessage,
  });
}

/// @nodoc
class _$BreathingStateCopyWithImpl<$Res, $Val extends BreathingState>
    implements $BreathingStateCopyWith<$Res> {
  _$BreathingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreathingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? exercises = null,
    Object? selectedExercise = freezed,
    Object? currentStepIndex = null,
    Object? stepProgress = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BreathingStatus,
            exercises: null == exercises
                ? _value.exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                      as List<BreathingExercise>,
            selectedExercise: freezed == selectedExercise
                ? _value.selectedExercise
                : selectedExercise // ignore: cast_nullable_to_non_nullable
                      as BreathingExercise?,
            currentStepIndex: null == currentStepIndex
                ? _value.currentStepIndex
                : currentStepIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            stepProgress: null == stepProgress
                ? _value.stepProgress
                : stepProgress // ignore: cast_nullable_to_non_nullable
                      as double,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreathingStateImplCopyWith<$Res>
    implements $BreathingStateCopyWith<$Res> {
  factory _$$BreathingStateImplCopyWith(
    _$BreathingStateImpl value,
    $Res Function(_$BreathingStateImpl) then,
  ) = __$$BreathingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    BreathingStatus status,
    List<BreathingExercise> exercises,
    BreathingExercise? selectedExercise,
    int currentStepIndex,
    double stepProgress,
    String? errorMessage,
  });
}

/// @nodoc
class __$$BreathingStateImplCopyWithImpl<$Res>
    extends _$BreathingStateCopyWithImpl<$Res, _$BreathingStateImpl>
    implements _$$BreathingStateImplCopyWith<$Res> {
  __$$BreathingStateImplCopyWithImpl(
    _$BreathingStateImpl _value,
    $Res Function(_$BreathingStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreathingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? exercises = null,
    Object? selectedExercise = freezed,
    Object? currentStepIndex = null,
    Object? stepProgress = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$BreathingStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BreathingStatus,
        exercises: null == exercises
            ? _value._exercises
            : exercises // ignore: cast_nullable_to_non_nullable
                  as List<BreathingExercise>,
        selectedExercise: freezed == selectedExercise
            ? _value.selectedExercise
            : selectedExercise // ignore: cast_nullable_to_non_nullable
                  as BreathingExercise?,
        currentStepIndex: null == currentStepIndex
            ? _value.currentStepIndex
            : currentStepIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        stepProgress: null == stepProgress
            ? _value.stepProgress
            : stepProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BreathingStateImpl extends _BreathingState {
  const _$BreathingStateImpl({
    this.status = BreathingStatus.initial,
    final List<BreathingExercise> exercises = const [],
    this.selectedExercise,
    this.currentStepIndex = 0,
    this.stepProgress = 0.0,
    this.errorMessage,
  }) : _exercises = exercises,
       super._();

  /// Estado actual del ejercicio
  @override
  @JsonKey()
  final BreathingStatus status;

  /// Lista de ejercicios disponibles
  final List<BreathingExercise> _exercises;

  /// Lista de ejercicios disponibles
  @override
  @JsonKey()
  List<BreathingExercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  /// Ejercicio seleccionado actualmente
  @override
  final BreathingExercise? selectedExercise;

  /// Índice del paso actual en el ejercicio
  @override
  @JsonKey()
  final int currentStepIndex;

  /// Progreso del paso actual (0.0 a 1.0)
  @override
  @JsonKey()
  final double stepProgress;

  /// Mensaje de error si existe
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'BreathingState(status: $status, exercises: $exercises, selectedExercise: $selectedExercise, currentStepIndex: $currentStepIndex, stepProgress: $stepProgress, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreathingStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ) &&
            (identical(other.selectedExercise, selectedExercise) ||
                other.selectedExercise == selectedExercise) &&
            (identical(other.currentStepIndex, currentStepIndex) ||
                other.currentStepIndex == currentStepIndex) &&
            (identical(other.stepProgress, stepProgress) ||
                other.stepProgress == stepProgress) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_exercises),
    selectedExercise,
    currentStepIndex,
    stepProgress,
    errorMessage,
  );

  /// Create a copy of BreathingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreathingStateImplCopyWith<_$BreathingStateImpl> get copyWith =>
      __$$BreathingStateImplCopyWithImpl<_$BreathingStateImpl>(
        this,
        _$identity,
      );
}

abstract class _BreathingState extends BreathingState {
  const factory _BreathingState({
    final BreathingStatus status,
    final List<BreathingExercise> exercises,
    final BreathingExercise? selectedExercise,
    final int currentStepIndex,
    final double stepProgress,
    final String? errorMessage,
  }) = _$BreathingStateImpl;
  const _BreathingState._() : super._();

  /// Estado actual del ejercicio
  @override
  BreathingStatus get status;

  /// Lista de ejercicios disponibles
  @override
  List<BreathingExercise> get exercises;

  /// Ejercicio seleccionado actualmente
  @override
  BreathingExercise? get selectedExercise;

  /// Índice del paso actual en el ejercicio
  @override
  int get currentStepIndex;

  /// Progreso del paso actual (0.0 a 1.0)
  @override
  double get stepProgress;

  /// Mensaje de error si existe
  @override
  String? get errorMessage;

  /// Create a copy of BreathingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreathingStateImplCopyWith<_$BreathingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
