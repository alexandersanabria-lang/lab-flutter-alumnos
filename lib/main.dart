import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

const Color morado = Color(0xFF5B3FC4);
const Color fondo = Color(0xFFF3F0FB);

// LISTAS Y MAPAS: cada alumno es un Map dentro de una List
final List<Map<String, dynamic>> alumnos = [
  {'nombre': 'Ana Torres', 'nota': 18},
  {'nombre': 'Luis García', 'nota': 12},
  {'nombre': 'María López', 'nota': 9},
  {'nombre': 'Carlos Ruiz', 'nota': 15},
];

// NUEVO (no visto en clase): widget propio que centra el contenido y limita
// su ancho máximo, para que en una página web no se estire a toda la pantalla.
class Centrado extends StatelessWidget {
  final double ancho;
  final Widget child;
  const Centrado({super.key, required this.ancho, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: ancho),
        child: child,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Alumnos',
      // TEMA GLOBAL: colores y estilos definidos una sola vez para toda la app
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: morado),
        scaffoldBackgroundColor: fondo,
        appBarTheme: const AppBarTheme(
          backgroundColor: morado,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: morado,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      // RUTAS: nombres de pantalla -> widget
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/menu': (context) => const MenuPage(),
        '/listar': (context) => const ListarAlumnosPage(),
        '/registrar': (context) => const RegistrarAlumnoPage(),
        '/perfil': (context) => const PerfilPage(),
      },
    );
  }
}

// ---------------- 1. LOGIN ----------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool ocultar = true; // controla si se ve la contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // NUEVO (no visto en clase): Image.asset carga una imagen
                    // LOCAL del proyecto (declarada en pubspec.yaml).
                    // errorBuilder muestra un ícono si no se encuentra.
                    Image.asset(
                      'assets/logo.png', // esto se usa en local
                      height: 80,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.school, size: 80, color: morado),
                    ),
                    const SizedBox(height: 12),
                    const Text('Iniciar Sesión',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text('Ingresa tus credenciales para continuar'),
                    const SizedBox(height: 24),
                    const TextField(
                      decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      obscureText: ocultar,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                              ocultar ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => ocultar = !ocultar),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/menu'),
                      child: const Text('LOGIN'),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text('¿Olvidaste tu contraseña?')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- 2. MENÚ ----------------
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de Maps para generar las opciones con un ListView
    final opciones = [
      {'icono': Icons.person_add, 'texto': 'Registrar Alumnos', 'ruta': '/registrar'},
      {'icono': Icons.list, 'texto': 'Listar Alumnos', 'ruta': '/listar'},
      {'icono': Icons.person, 'texto': 'Perfil', 'ruta': '/perfil'},
      {'icono': Icons.logout, 'texto': 'Logout', 'ruta': '/'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Menú'),
      ),
      body: Centrado(
        ancho: 700,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: opciones.map((op) {
            return Card(
              color: Colors.white,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Icon(op['icono'] as IconData, color: morado),
                title: Text(op['texto'] as String),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  if (op['ruta'] == '/') {
                    // NUEVO (no visto en clase): borra el historial de pantallas
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (r) => false);
                  } else {
                    Navigator.pushNamed(context, op['ruta'] as String);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ---------------- 3. LISTAR ALUMNOS ----------------
class ListarAlumnosPage extends StatefulWidget {
  const ListarAlumnosPage({super.key});

  @override
  State<ListarAlumnosPage> createState() => _ListarAlumnosPageState();
}

class _ListarAlumnosPageState extends State<ListarAlumnosPage> {
  String filtro = '';

  @override
  Widget build(BuildContext context) {
    // NUEVO (no visto en clase): where() filtra la lista según el buscador
    final lista = alumnos
        .where((a) =>
            (a['nombre'] as String).toLowerCase().contains(filtro.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumnos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(context, '/registrar');
              setState(() {}); // refresca la lista al volver
            },
          ),
        ],
      ),
      body: Centrado(
        ancho: 900,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: TextField(
                onChanged: (v) => setState(() => filtro = v),
                decoration: const InputDecoration(
                    hintText: 'Buscar alumno...',
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
            Expanded(
              // LISTVIEW.BUILDER: construye cada item a partir de la lista
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: lista.length,
                itemBuilder: (context, i) {
                  final a = lista[i];
                  final aprobado = (a['nota'] as int) >= 11;
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: const CircleAvatar(
                          backgroundColor: morado,
                          child: Icon(Icons.school, color: Colors.white)),
                      title: Text(a['nombre'] as String),
                      subtitle: Text('Nota: ${a['nota']}'),
                      trailing: Chip(
                        label: Text(aprobado ? 'Aprobado' : 'Desaprobado',
                            style: TextStyle(
                                fontSize: 12,
                                color: aprobado ? Colors.green : Colors.red)),
                        backgroundColor: aprobado
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- 4. REGISTRAR ALUMNO ----------------
class RegistrarAlumnoPage extends StatefulWidget {
  const RegistrarAlumnoPage({super.key});

  @override
  State<RegistrarAlumnoPage> createState() => _RegistrarAlumnoPageState();
}

class _RegistrarAlumnoPageState extends State<RegistrarAlumnoPage> {
  final nombre = TextEditingController();
  final apellido = TextEditingController();
  final nota = TextEditingController();

  void guardar() {
    final n = int.tryParse(nota.text);
    if (nombre.text.isEmpty || n == null || n < 0 || n > 20) {
      // NUEVO (no visto en clase): SnackBar muestra un mensaje temporal
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completa los datos (nota 0 - 20)')));
      return;
    }
    alumnos.add({'nombre': '${nombre.text} ${apellido.text}', 'nota': n});
    Navigator.pop(context); // vuelve a la pantalla anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Alumno')),
      body: Centrado(
        ancho: 560,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextField(
                      controller: nombre,
                      decoration:
                          const InputDecoration(hintText: 'Nombre del alumno')),
                  const SizedBox(height: 12),
                  TextField(
                      controller: apellido,
                      decoration: const InputDecoration(hintText: 'Apellido')),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nota,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'Nota (0 - 20)',
                        suffixIcon: Icon(Icons.school)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: guardar, child: const Text('GUARDAR')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- 5. PERFIL ----------------
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final datos = [
      {'icono': Icons.person, 'campo': 'Nombre', 'valor': 'María González'},
      {'icono': Icons.email, 'campo': 'Email', 'valor': 'maria.gonzalez@correo.com'},
      {'icono': Icons.phone, 'campo': 'Teléfono', 'valor': '912345678'},
      {'icono': Icons.settings, 'campo': 'Roles', 'valor': 'Docente'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Centrado(
        ancho: 560,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // NUEVO (no visto en clase): Stack superpone el lápiz
                  // sobre el avatar
                  Stack(
                    children: [
                      ClipOval(
                        // esto se usa en local: carga la foto desde assets
                        child: Image.asset(
                          'assets/perfil.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const CircleAvatar(
                            radius: 50,
                            backgroundColor: morado,
                            child: Icon(Icons.person,
                                size: 56, color: Colors.white),
                          ),
                        ),
                      ),
                      const Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 11,
                            backgroundColor: morado,
                            child:
                                Icon(Icons.edit, size: 13, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('María González',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('maria.gonzalez@correo.com'),
                  const SizedBox(height: 16),
                  ...datos.map((d) => ListTile(
                        leading: Icon(d['icono'] as IconData, color: morado),
                        title: Text(d['campo'] as String),
                        trailing: Text(d['valor'] as String),
                      )),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      foregroundColor: morado,
                      side: const BorderSide(color: morado),
                    ),
                    child: const Text('EDITAR PERFIL'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}