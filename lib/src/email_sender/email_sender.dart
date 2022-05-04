import 'dart:async';

import 'package:backend/backend.dart';
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

  FutureOr<bool> sendInvite({
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
      ..html = _createHtml(refId, message);

    try {
      await connection.send(email);
      return true;
    } on MailerException catch (_) {
      return false;
    }
  }

  String _createHtml(String refId, String? message) {
    final server = Server();

    final stringBuffer = StringBuffer()
      ..writeln("<h1>Here's your invite link:</h1>")
      ..writeln('<p>https://${server.host}/organization/join/$refId</p>')
      ..writeln('<p>This link will expire in one week.</p>')
      ..writeln("<p>If you don't want to join the organization, you can ignore this email.</p>")
      ..writeln('<h2>$message</h2>')
      ..writeln('<p>Thanks,</p>')
      ..writeln('<p>${Constants.inviteEmailUserName}</p>');

    return stringBuffer.toString();
  }
}
