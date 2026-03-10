enum UserRole { teacher, student }

class AppUser {
  final String name;
  final String email;
  final String password;
  final UserRole role;

  const AppUser({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}

const mockUsers = [
  AppUser(
    name: 'Augusto',
    email: 'augusto@uninorte.edu.co',
    password: '1234',
    role: UserRole.teacher,
  ),
  AppUser(
    name: 'Maria',
    email: 'maria@uninorte.edu.co',
    password: '1234',
    role: UserRole.student,
  ),
];