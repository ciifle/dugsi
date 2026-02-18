
import '../models/dummy_user.dart';


class School {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String logo;

  School({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.logo,
  });
}

class DummySchoolService {
  Future<School?> getSchoolById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (id == 'school_1') {
      return School(
        id: 'school_1',
        name: 'Kobac High School',
        email: 'info@kobac.edu',
        phone: '+1 234 567 890',
        address: '123 Education Lane, Learning City',
        logo: '', // Empty or URL
      );
    }
    return null;
  }
  Future<int> getStudentCount() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 120; // Dummy count
  }

  Future<int> getTeacherCount() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 15; // Dummy count
  }

  Future<List<DummyUser>> getAllUsersForAdmin() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      DummyUser(id: '1', name: "School Admin", email: "admin@school.com", role: UserRole.schoolAdmin, password: '', phone: '1234567890', schoolId: 'school_1'),
      DummyUser(id: '2', name: "Teacher User", email: "teacher@school.com", role: UserRole.teacher, password: '', phone: '0987654321', schoolId: 'school_1'),
      DummyUser(id: '3', name: "Student User", email: "student@school.com", role: UserRole.student, password: '', phone: '5566778899', schoolId: 'school_1'),
      DummyUser(id: '4', name: "Parent User", email: "parent@school.com", role: UserRole.parent, password: '', phone: '1122334455', schoolId: 'school_1'),
      DummyUser(id: '5', name: "Another Student", email: "student2@school.com", role: UserRole.student, password: '', phone: '6677889900', schoolId: 'school_1'),
    ];
  }
}
