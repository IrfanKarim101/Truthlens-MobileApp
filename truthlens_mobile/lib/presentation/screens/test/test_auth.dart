import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/blocs/auth/auth_bloc.dart';
import '../../../business_logic/blocs/auth/auth_event.dart';
import '../../../business_logic/blocs/auth/auth_state.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({Key? key}) : super(key: key);

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  final _emailController = TextEditingController(text: 'test@example.com');
  final _passwordController = TextEditingController(text: 'password123');
  final _nameController = TextEditingController(text: 'John Doe');
  final _confirmPasswordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth BLoC Testing'),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ Logged in as ${state.user.fullName}'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is Unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🔓 Logged out'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Current State Display
                _buildStateCard(state),
                
                const SizedBox(height: 20),
                
                // Login Section
                _buildSectionTitle('Login Test'),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(
                                LoginRequested(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                        },
                  child: state is AuthLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('TEST LOGIN'),
                ),
                
                const SizedBox(height: 30),
                
                // Signup Section
                _buildSectionTitle('Signup Test'),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(
                                SignupRequested(
                                  fullName: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  confirmPassword: _confirmPasswordController.text,
                                ),
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('TEST SIGNUP'),
                ),
                
                const SizedBox(height: 30),
                
                // Other Actions
                _buildSectionTitle('Other Actions'),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const CheckAuthStatus(),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Check Status'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AutoLoginRequested(),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        child: const Text('Auto Login'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const LogoutRequested());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('LOGOUT'),
                ),
                
                const SizedBox(height: 30),
                
                // Test Scenarios
                _buildSectionTitle('Quick Test Scenarios'),
                _buildTestScenario(
                  context,
                  'Test Invalid Email',
                  'invalid-email',
                  'password123',
                ),
                _buildTestScenario(
                  context,
                  'Test Empty Fields',
                  '',
                  '',
                ),
                _buildTestScenario(
                  context,
                  'Test Short Password',
                  'test@example.com',
                  '123',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStateCard(AuthState state) {
    Color color;
    String stateText;
    String details;

    if (state is AuthInitial) {
      color = Colors.grey;
      stateText = 'Initial';
      details = 'No authentication action yet';
    } else if (state is AuthLoading) {
      color = Colors.blue;
      stateText = 'Loading';
      details = 'Processing authentication...';
    } else if (state is Authenticated) {
      color = Colors.green;
      stateText = 'Authenticated';
      details = 'User: ${state.user.fullName}\nEmail: ${state.user.email}';
    } else if (state is Unauthenticated) {
      color = Colors.orange;
      stateText = 'Unauthenticated';
      details = state.message ?? 'User is not logged in';
    } else if (state is AuthError) {
      color = Colors.red;
      stateText = 'Error';
      details = state.message;
    } else {
      color = Colors.grey;
      stateText = 'Unknown';
      details = 'Unknown state';
    }

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: color),
                const SizedBox(width: 8),
                Text(
                  'Current State: $stateText',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              details,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTestScenario(
    BuildContext context,
    String title,
    String email,
    String password,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: () {
          _emailController.text = email;
          _passwordController.text = password;
          context.read<AuthBloc>().add(
                LoginRequested(
                  email: email,
                  password: password,
                ),
              );
        },
        child: Text(title),
      ),
    );
  }
}