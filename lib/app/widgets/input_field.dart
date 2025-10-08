import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de entrada reutilizable con diseño Material 3 y glassmorphism
/// Proporciona validación, accesibilidad y manejo de estados
class InputField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final Color? fillColor;

  const InputField({
    Key? key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.validator,
    this.autovalidateMode,
    this.inputFormatters,
    this.focusNode,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> with TickerProviderStateMixin {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    // Feedback háptico suave al obtener foco
    if (_focusNode.hasFocus) {
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    // Colores adaptativos más elegantes para integración glassmorphism
    final borderColor = widget.errorText != null
        ? colorScheme.error
        : _isFocused
            ? colorScheme.primary
            : (isDark 
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.withOpacity(0.3));
    
    // Fondo translúcido que se integra con el glassmorphism del contenedor padre
    final fillColor = widget.fillColor ?? 
        (isDark 
            ? Colors.white.withOpacity(0.08) // Muy sutil en modo oscuro
            : Colors.white.withOpacity(0.6)); // Translúcido en modo claro

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label opcional
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        
        // Campo de texto principal con integración glassmorphism
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12), // Radio más sutil
            border: Border.all(
              color: borderColor,
              width: _isFocused ? 1.5 : 0.8, // Bordes más finos
            ),
            color: fillColor,
            // Sombra muy sutil que no compita con el glassmorphism
            boxShadow: _isFocused ? [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onEditingComplete: widget.onEditingComplete,
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
            inputFormatters: widget.inputFormatters,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 16, // Tamaño coherente
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5), // Más sutil
                fontSize: 16,
              ),
              prefixIcon: widget.prefixIcon != null 
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: widget.prefixIcon,
                  )
                : null,
              suffixIcon: widget.suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8, right: 12),
                    child: widget.suffixIcon,
                  )
                : null,
              // Padding interno más aireado para elegancia
              contentPadding: widget.contentPadding ?? 
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              // Sin bordes ya que usamos el contenedor decorado
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              counterText: '', // Ocultar contador por defecto
              // Asegurar que no hay color de fondo adicional
              filled: false,
            ),
          ),
        ),
        
        // Texto de ayuda o error
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.errorText ?? widget.helperText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: widget.errorText != null
                    ? colorScheme.error
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Campo de contraseña con toggle de visibilidad
class PasswordField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;

  const PasswordField({
    Key? key,
    this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.enabled = true,
    this.autovalidateMode,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return InputField(
      labelText: widget.labelText,
      hintText: widget.hintText ?? 'Ingresa tu contraseña',
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: _toggleVisibility,
        tooltip: _obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
      ),
    );
  }
}

/// Campo de email con validación integrada
class EmailField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final bool enabled;
  final String? customValidator;

  const EmailField({
    Key? key,
    this.labelText,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.enabled = true,
    this.customValidator,
  }) : super(key: key);

  String? _validateEmail(String? value) {
    if (customValidator != null) return customValidator;
    
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu email';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingresa un email válido';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InputField(
      labelText: labelText,
      hintText: hintText ?? 'ejemplo@correo.com',
      controller: controller,
      validator: _validateEmail,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

/// Campo de texto multilínea para comentarios o descripciones
class TextAreaField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final int? maxLength;
  final bool enabled;

  const TextAreaField({
    Key? key,
    this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.maxLines = 4,
    this.maxLength,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputField(
      labelText: labelText,
      hintText: hintText,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: TextInputType.multiline,
      contentPadding: const EdgeInsets.all(16),
    );
  }
}