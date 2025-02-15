class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title cannot be empty';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description cannot be empty';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category cannot be empty';
    }
    return null;
  }

  static String? validateDueDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Due date cannot be empty';
    }
    // Additional validation for date format can be added here
    return null;
  }
}
