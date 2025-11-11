import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../domain/entities/breathing_exercise.dart';
import '../../../styles/app_colors.dart';

/// Widget que muestra la lista de ejercicios disponibles con animaciones
/// 
/// Usa glassmorphism para el efecto visual y staggered animations
/// para las transiciones de entrada.
class ExerciseSelectionList extends StatelessWidget {
  final List<BreathingExercise> exercises;
  final Function(int index) onExerciseSelected;

  const ExerciseSelectionList({
    super.key,
    required this.exercises,
    required this.onExerciseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _ExerciseCard(
                    exercise: exercise,
                    onTap: () => onExerciseSelected(index),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Card individual de ejercicio con efecto glassmorphism
/// Aplicando Heurísticas de Nielsen para mejor UX
class _ExerciseCard extends StatelessWidget {
  final BreathingExercise exercise;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Nielsen: Reconocimiento en lugar de memorización - Visual feedback
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        // Nielsen: Visibilidad del estado del sistema - Feedback visual al tap
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.05),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 170.h, // Altura optimizada para 3 líneas de descripción
          borderRadius: 16.r,
          blur: 20,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.card.withValues(alpha: 0.2),
              AppColors.card.withValues(alpha: 0.1),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.3),
              AppColors.secondary.withValues(alpha: 0.2),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título y duración
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nielsen: Reconocimiento - Título descriptivo
                    Expanded(
                      child: Text(
                        exercise.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.foreground,
                          height: 1.3,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Nielsen: Visibilidad del estado - Badge de duración
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 14.sp,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${exercise.totalDurationInSeconds ~/ 60} min',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 10.h),
                
                // Nielsen: Reconocimiento - Descripción completa y legible
                Text(
                  exercise.description,
                  maxLines: 3, // 3 líneas para mejor proporción
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.4,
                    color: AppColors.mutedForeground,
                  ),
                ),
                
                SizedBox(height: 14.h),
                
                // Nielsen: Reconocimiento - Metadatos e indicador de acción
                Row(
                  children: [
                    // Indicador de pasos
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.air,
                            size: 14.sp,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${exercise.stepCount} pasos',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Nielsen: Correspondencia con el mundo real - CTA claro
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            size: 18.sp,
                            color: AppColors.primaryForeground,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Comenzar',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryForeground,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
