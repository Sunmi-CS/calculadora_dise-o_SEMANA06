import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
return MaterialApp(
  title: 'Calculadora Científica',
  debugShowCheckedModeBanner: false,
  theme: ThemeData.dark(),
  home: const CalculadoraScreen(),
);  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String _display = '0';
  String _expresion = '';
  String _resultado = '';
  double _valorAnterior = 0;
  String _operacion = '';
  bool _nuevoNumero = true;
  bool _modoShift = false;
  bool _modoAlpha = false;
  bool _modoHyp = false;

  // Colores exactos de la imagen
  static const Color _bgPrincipal = Color(0xFF0A0A0A);
  static const Color _bgTeclado = Color(0xFF111111);
  static const Color _colorShift = Color(0xFFD4A017);      // amarillo dorado SHIFT
  static const Color _colorAlpha = Color(0xFF6DBF67);      // verde ALPHA
  static const Color _colorAzul = Color(0xFF1A3A6B);       // azul oscuro operadores
  static const Color _colorNaranja = Color(0xFFCC5500);    // naranja DEL
  static const Color _colorRojo = Color(0xFFB22222);       // rojo AC
  static const Color _colorGris = Color(0xFF2A2A2A);       // gris oscuro botones función
  static const Color _colorGrisClaro = Color(0xFF3A3A3A);  // gris medio
  static const Color _colorTexto = Color(0xFFDDDDDD);
  static const Color _colorDisplay = Color(0xFF0D1117);
  static const Color _colorVerde = Color(0xFF1A3A6B);      // azul oscuro igual = imagen

  void _presionarBoton(String valor) {
    setState(() {
      if (valor == 'SHIFT') {
        _modoShift = !_modoShift;
        _modoAlpha = false;
        return;
      }
      if (valor == 'ALPHA') {
        _modoAlpha = !_modoAlpha;
        _modoShift = false;
        return;
      }
      if (valor == 'HYP') {
        _modoHyp = !_modoHyp;
        return;
      }
      if (valor == 'AC') {
        _display = '0';
        _expresion = '';
        _resultado = '';
        _valorAnterior = 0;
        _operacion = '';
        _nuevoNumero = true;
        _modoShift = false;
        _modoAlpha = false;
        _modoHyp = false;
        return;
      }
      if (valor == 'DEL') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
          _nuevoNumero = true;
        }
        return;
      }
      if (valor == '=') {
        _calcularResultado();
        return;
      }
      if (['+', '-', '×', '÷', '^'].contains(valor)) {
        _valorAnterior = double.tryParse(_display) ?? 0;
        _operacion = valor;
        _expresion = '$_display $valor';
        _nuevoNumero = true;
        return;
      }
      if (valor == '.' ) {
        if (_nuevoNumero) {
          _display = '0.';
          _nuevoNumero = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
        return;
      }
      // Funciones matemáticas
      if (valor == 'sin' || valor == 'sin⁻¹') {
        _aplicarFuncion(valor);
        return;
      }
      if (valor == 'cos' || valor == 'cos⁻¹') {
        _aplicarFuncion(valor);
        return;
      }
      if (valor == 'tan' || valor == 'tan⁻¹') {
        _aplicarFuncion(valor);
        return;
      }
      if (valor == 'ln' || valor == 'eˣ') {
        _aplicarFuncion(valor);
        return;
      }
      if (valor == 'log' || valor == '10ˣ') {
        _aplicarFuncion(valor);
        return;
      }
      if (valor == '√' || valor == 'x²') {
        _aplicarFuncion(valor);
        return;
      }
      if (valor == 'π') {
        _display = math.pi.toStringAsFixed(9);
        _nuevoNumero = false;
        return;
      }
      if (valor == 'e') {
        _display = math.e.toStringAsFixed(9);
        _nuevoNumero = false;
        return;
      }
      if (valor == '(') {
        _expresion += '(';
        return;
      }
      if (valor == ')') {
        _expresion += ')';
        return;
      }
      if (valor == '±') {
        if (_display != '0') {
          if (_display.startsWith('-')) {
            _display = _display.substring(1);
          } else {
            _display = '-$_display';
          }
        }
        return;
      }
      if (valor == 'x!') {
        double num = double.tryParse(_display) ?? 0;
        if (num >= 0 && num == num.roundToDouble() && num <= 20) {
          int n = num.toInt();
          int fact = 1;
          for (int i = 2; i <= n; i++) fact *= i;
          _display = fact.toString();
        } else {
          _display = 'Error';
        }
        _nuevoNumero = true;
        return;
      }
      if (valor == '1/x') {
        double num = double.tryParse(_display) ?? 0;
        if (num != 0) {
          _display = _formatearNumero(1 / num);
        } else {
          _display = 'Error';
        }
        _nuevoNumero = true;
        return;
      }
      // Dígitos normales
      if (_nuevoNumero) {
        _display = valor;
        _nuevoNumero = false;
      } else {
        if (_display == '0' && valor != '.') {
          _display = valor;
        } else {
          if (_display.length < 15) {
            _display += valor;
          }
        }
      }
      _modoShift = false;
    });
  }

  void _aplicarFuncion(String funcion) {
    double num = double.tryParse(_display) ?? 0;
    double resultado = 0;
    try {
      switch (funcion) {
        case 'sin':
          resultado = math.sin(num * math.pi / 180);
          break;
        case 'sin⁻¹':
          resultado = math.asin(num) * 180 / math.pi;
          break;
        case 'cos':
          resultado = math.cos(num * math.pi / 180);
          break;
        case 'cos⁻¹':
          resultado = math.acos(num) * 180 / math.pi;
          break;
        case 'tan':
          resultado = math.tan(num * math.pi / 180);
          break;
        case 'tan⁻¹':
          resultado = math.atan(num) * 180 / math.pi;
          break;
        case 'ln':
          resultado = math.log(num);
          break;
        case 'eˣ':
          resultado = math.exp(num);
          break;
        case 'log':
          resultado = math.log(num) / math.log(10);
          break;
        case '10ˣ':
          resultado = math.pow(10, num).toDouble();
          break;
        case '√':
          resultado = math.sqrt(num);
          break;
        case 'x²':
          resultado = num * num;
          break;
      }
      _display = _formatearNumero(resultado);
    } catch (e) {
      _display = 'Error';
    }
    _nuevoNumero = true;
    _modoShift = false;
  }

  void _calcularResultado() {
    double numActual = double.tryParse(_display) ?? 0;
    double resultado = 0;
    switch (_operacion) {
      case '+':
        resultado = _valorAnterior + numActual;
        break;
      case '-':
        resultado = _valorAnterior - numActual;
        break;
      case '×':
        resultado = _valorAnterior * numActual;
        break;
      case '÷':
        if (numActual != 0) {
          resultado = _valorAnterior / numActual;
        } else {
          _display = 'Error';
          return;
        }
        break;
      case '^':
        resultado = math.pow(_valorAnterior, numActual).toDouble();
        break;
      default:
        return;
    }
    _resultado = _formatearNumero(resultado);
    _display = _resultado;
    _expresion = '';
    _operacion = '';
    _nuevoNumero = true;
  }

  String _formatearNumero(double num) {
    if (num == num.roundToDouble() && num.abs() < 1e15) {
      return num.toInt().toString();
    }
    String s = num.toStringAsPrecision(10);
    // quitar ceros al final
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }

  // ── Widgets de botones ──────────────────────────────────────────────

  Widget _boton({
    required String label,
    String? labelShift,
    String? labelAlpha,
    required Color color,
    Color? colorTexto,
    double fontSize = 14,
    double flex = 1,
    EdgeInsets? padding,
  }) {
    String etiqueta = label;
    if (_modoShift && labelShift != null) etiqueta = labelShift;
    if (_modoAlpha && labelAlpha != null) etiqueta = labelAlpha;

    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(3),
        child: GestureDetector(
          onTap: () {
            String valorPulsar = label;
            if (_modoShift && labelShift != null) valorPulsar = labelShift;
            if (_modoAlpha && labelAlpha != null) valorPulsar = labelAlpha;
            _presionarBoton(valorPulsar);
          },
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (labelShift != null)
                  Text(
                    labelShift,
                    style: TextStyle(
                      color: _colorShift,
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  etiqueta,
                  style: TextStyle(
                    color: colorTexto ?? _colorTexto,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (labelAlpha != null)
                  Text(
                    labelAlpha,
                    style: TextStyle(
                      color: _colorAlpha,
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonEspecial({
    required String label,
    required Color color,
    required VoidCallback onTap,
    Color? colorTexto,
    double fontSize = 13,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
              border: (_modoShift && label == 'SHIFT') ||
                      (_modoAlpha && label == 'ALPHA')
                  ? Border.all(color: Colors.white, width: 1.5)
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: colorTexto ?? _colorTexto,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrincipal,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER / LOGO ─────────────────────────────────────
            Container(
              color: const Color(0xFF050505),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.calculate, color: _colorShift, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Calculadora Científica',
                    style: TextStyle(
                      color: _colorTexto,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  _indicador('S', _modoShift, _colorShift),
                  const SizedBox(width: 6),
                  _indicador('A', _modoAlpha, _colorAlpha),
                  const SizedBox(width: 6),
                  _indicador('HYP', _modoHyp, _colorAzul),
                ],
              ),
            ),

            // ── DISPLAY ───────────────────────────────────────────
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFB8C9A0),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF8A9A70), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Expresión arriba
                  Text(
                    _expresion.isEmpty ? ' ' : _expresion,
                    style: const TextStyle(
                      color: Color(0xFF3A4A2A),
                      fontSize: 60,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Resultado principal
                  Text(
                    _display,
                    style: const TextStyle(
                      color: Color(0xFF1A2A10),
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── TECLADO ───────────────────────────────────────────
            Expanded(
              child: Container(
                color: _bgTeclado,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  children: [
                    // Fila 1: SHIFT ALPHA ← MODE 2nd
                    Row(children: [
                      _botonEspecial(
                        label: 'SHIFT',
                        color: _modoShift ? _colorShift : const Color(0xFF795548),
                        colorTexto: _modoShift ? Colors.black : _colorShift,
                        onTap: () => _presionarBoton('SHIFT'),
                      ),
                      _botonEspecial(
                        label: 'ALPHA',
                        color: _modoAlpha ? _colorAlpha : const Color(0xFF1B5E20),
                        colorTexto: _modoAlpha ? Colors.black : _colorAlpha,
                        onTap: () => _presionarBoton('ALPHA'),
                      ),
                      _botonEspecial(
                        label: '←',
                        color: _colorGris,
                        onTap: () {},
                      ),
                      _botonEspecial(
                        label: 'MODE',
                        color: _colorGris,
                        onTap: () {},
                      ),
                      _botonEspecial(
                        label: '2nd',
                        color: const Color(0xFF4A148C),
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 4),

                    // Fila 2: CALC dx x² x³ Log Ln
                    Row(children: [
                      _boton(label: 'CALC', labelShift: 'd/dx', color: _colorGris, fontSize: 11),
                      _boton(label: 'd/dx', labelShift: '∫dx', color: _colorGris, fontSize: 11),
                      _boton(label: '▲', color: _colorGris, labelShift: 'x²', fontSize: 12),
                      _boton(label: 'x□', labelShift: 'x³', color: _colorGris, fontSize: 11),
                      _boton(label: 'Log', labelShift: '10ˣ', color: _colorGris, fontSize: 12),
                      _boton(label: 'Ln', labelShift: 'eˣ', color: _colorGris, fontSize: 12),
                    ]),
                    const SizedBox(height: 4),

                    // Fila 3: (-) HYP sin cos tan
                    Row(children: [
                      _boton(label: '(', labelShift: ')', color: _colorGris),
                      _boton(label: 'HYP', labelShift: 'HYP', color: const Color(0xFF0D47A1), colorTexto: Colors.white, fontSize: 11),
                      _boton(label: 'sin', labelShift: 'sin⁻¹', color: _colorGrisClaro, fontSize: 12),
                      _boton(label: 'cos', labelShift: 'cos⁻¹', color: _colorGrisClaro, fontSize: 12),
                      _boton(label: 'tan', labelShift: 'tan⁻¹', color: _colorGrisClaro, fontSize: 12),
                    ]),
                    const SizedBox(height: 4),

                    // Fila 4: RCL ENG ( ) S↔D M+
                    Row(children: [
                      _boton(label: 'RCL', labelShift: 'STO', color: _colorGris, fontSize: 11),
                      _boton(label: 'ENG', labelShift: '←', color: _colorGris, fontSize: 11),
                      _boton(label: '(', labelShift: '{', color: _colorGris),
                      _boton(label: ')', labelShift: '}', color: _colorGris),
                      _boton(label: 'S⇔D', labelShift: '', color: _colorGris, fontSize: 10),
                      _boton(label: 'M+', labelShift: 'M-', color: _colorGris, fontSize: 11),
                    ]),
                    const SizedBox(height: 4),

                    // Fila 5: 7 8 9 DEL AC
                    Row(children: [
                      _boton(label: '7', labelShift: '7', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _boton(label: '8', labelShift: '8', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _boton(label: '9', labelShift: '9', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _botonEspecial(label: 'DEL', color: _colorNaranja, onTap: () => _presionarBoton('DEL')),
                      _botonEspecial(label: 'AC', color: _colorRojo, onTap: () => _presionarBoton('AC')),
                    ]),
                    const SizedBox(height: 4),

                    // Fila 6: 4 5 6 × ÷
                    Row(children: [
                      _boton(label: '4', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _boton(label: '5', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _boton(label: '6', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _boton(label: '×', color: _colorAzul, fontSize: 18),
                      _boton(label: '÷', color: _colorAzul, fontSize: 18),
                    ]),
                    const SizedBox(height: 4),

                    // Fila 7: 1 2 3 + -
                    Row(children: [
                      _boton(label: '1', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _boton(label: '2', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _boton(label: '3', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _boton(label: '+', color: _colorAzul, fontSize: 18),
                      _boton(label: '-', color: _colorAzul, fontSize: 18),
                    ]),
                    const SizedBox(height: 4),

                    // Fila 8: 0 . × 10ˣ Ans =
                    Row(children: [
                      _boton(label: '0', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _boton(label: '.', color: const Color(0xFF1E1E1E), fontSize: 18),
                      _boton(label: '×10ˣ', labelShift: 'π', color: _colorGrisClaro, fontSize: 10),
                      _boton(label: 'Ans', labelShift: '%', color: _colorGrisClaro, fontSize: 12),
                      _botonEspecial(
                        label: '=',
                        color: _colorVerde,
                        colorTexto: Colors.black,
                        fontSize: 20,
                        onTap: () => _presionarBoton('='),
                      ),
                    ]),

                    // Fila extra: √ x² x! 1/x ±
                    const SizedBox(height: 4),
                    Row(children: [
                      _boton(label: '√', labelShift: 'x²', color: _colorGrisClaro, fontSize: 13),
                      _boton(label: 'x²', labelShift: 'x³', color: _colorGrisClaro, fontSize: 12),
                      _boton(label: 'x!', color: _colorGrisClaro, fontSize: 12),
                      _boton(label: '1/x', color: _colorGrisClaro, fontSize: 11),
                      _boton(label: '±', color: _colorGrisClaro, fontSize: 14),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _indicador(String texto, bool activo, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: activo ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: activo ? color : color.withOpacity(0.3)),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: activo ? Colors.black : color.withOpacity(0.5),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}