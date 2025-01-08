class UpdateUserData {
  final String? fullName;
  final String? department;
  final String? level;

  UpdateUserData({
    this.fullName,
    this.department,
    this.level,
  });

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    if (fullName != null) data['fullName'] = fullName;
    if (department != null) data['department'] = department;
    if (level != null) data['level'] = level;
    return data;
  }
}
