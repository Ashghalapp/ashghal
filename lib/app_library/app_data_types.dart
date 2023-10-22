enum Gender { male, female }

/// enum to present the status of comment to control the comment widgets easily
enum CommentStatus { sending, faild, recieved }

/// نوع بيانات يحتوي على العمليات التي يمكن عملها على البوست
enum OperationsOnPostPopupMenuValues { save, report, copy }


/// نوع بيانات يحتوي على العمليات التي يمكن عملها على التعليق
enum OperationsOnCommentPopupMenuValues { edit, delete, report }

/// نوع بيانات يحتوي على العمليات التي يمكن عملها على البوست التي نشرها المستخدم
enum OperationsOnCurrentUserPostPopupMenuValues {edit, delete, save}