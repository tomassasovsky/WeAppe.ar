import 'package:backend/backend.dart';
import 'package:backend/src/organization/models/organization.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailSenderService {
  EmailSenderService();

  late SmtpServer smtpServer = SmtpServer(
    Constants.inviteEmailHost,
    ssl: true,
    username: Constants.inviteEmailAccount,
    password: Constants.inviteEmailPassword,
    port: Constants.inviteEmailPort,
  );

  late PersistentConnection connection = PersistentConnection(
    smtpServer,
  );

  Future<bool> sendInvite({
    required String to,
    required Organization organization,
    required String refId,
    String? message,
  }) async {
    final email = Message()
      ..from = Address(
        Constants.inviteEmailAccount,
        Constants.inviteEmailUserName,
      )
      ..recipients.add(to)
      ..subject = 'Invitation to join the ${organization.name} organization'
      ..html =
          "<h1>Here's your invite link:</h1>\n<p>https://${Constants.host}/organization/join/$refId</p>\n<p>This link will expire in one week.</p>\n<p>If you don't want to join the organization, you can ignore this email.</p>\n<h2>$message</h2>\n<p>Thanks,</p>\n<p>${Constants.inviteEmailUserName}</p>";

    try {
      await connection.send(email);
      return true;
    } on MailerException catch (_) {
      return false;
    }
  }
}
