// class Roles {
//   String roleString  = "Student";
//   Role(String r) : roleString = r;
//
//   factory Role.student() => Role("Student");
//   factory Role.courseOrganiser() => Role("Course Organiser");
//
//   @override
//   String toString() => roleString;
//
//
// }
enum Role { student, courseOrganiser }

class RoleToString {
  static String student = "Student";
  static String courseOrganiser = "Course Organiser";
}
