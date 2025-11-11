import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/repositories/breathing_repository_impl.dart';
import '../../../domain/usecases/get_breathing_exercises.dart';
import '../../styles/app_colors.dart';
import '../breathing/breathing_cubit.dart';
import '../breathing/breathing_state.dart';
import '../breathing/widgets/exercise_selection_list.dart';
import '../breathing/widgets/breathing_animation_view.dart';

/// Página principal de ejercicios de respiración
/// 
/// Usa BlocProvider para inyectar el BreathingCubit y muestra
/// condicionalmente la lista de ejercicios o la vista de ejercicio activo.
class BreathingPage extends StatelessWidget {
  const BreathingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Crear instancias de las dependencias
        final repository = BreathingRepositoryImpl();
        final useCase = GetBreathingExercises(repository);
        final cubit = BreathingCubit(useCase);
        
        // Cargar ejercicios automáticamente
        cubit.loadExercises();
        
        return cubit;
      },
      child: const _BreathingPageContent(),
    );
  }
}

class _BreathingPageContent extends StatelessWidget {
  const _BreathingPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<BreathingCubit, BreathingState>(
          builder: (context, state) {
            // Mostrar loading
            if (state.status == BreathingStatus.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }
            
            // Mostrar error
            if (state.status == BreathingStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: AppColors.destructive,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.errorMessage ?? 'Error desconocido',
                      style: GoogleFonts.lato(
                        fontSize: 16.sp,
                        color: AppColors.foreground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BreathingCubit>().loadExercises();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.primaryForeground,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Reintentar',
                        style: GoogleFonts.lato(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            
            // Mostrar vista de ejercicio activo o lista
            if (state.selectedExercise != null) {
              return const BreathingAnimationView();
            }
            
            // Mostrar lista de ejercicios
            return Column(
              children: [
                // Header
                _buildHeader(context),
                
                // Lista de ejercicios
                Expanded(
                  child: ExerciseSelectionList(
                    exercises: state.exercises,
                    onExerciseSelected: (index) {
                      context.read<BreathingCubit>().selectExercise(index);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ejercicios de Respiración',
            style: GoogleFonts.lato(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.foreground,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Selecciona un ejercicio para comenzar tu práctica',
            style: GoogleFonts.lato(
              fontSize: 16.sp,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
