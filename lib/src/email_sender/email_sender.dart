import 'dart:async';

import 'package:backend/backend.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:retry/retry.dart';

class EmailSenderService {
  EmailSenderService();

  late SmtpServer smtpServer = SmtpServer(
    Constants.inviteEmailHost,
    ssl: true,
    username: Constants.inviteEmailAccount,
    password: Constants.inviteEmailPassword,
    port: Constants.inviteEmailPort,
  );

  late PersistentConnection connection = PersistentConnection(smtpServer);

  FutureOr<bool> sendInvite({
    required String to,
    required Organization organization,
    required String refId,
    String? message,
  }) async {
    final subject = 'Invitation to join the ${organization.name} organization';
    final htmlMessage = (StringBuffer()
          ..writeln("<h1>Here's your invite link:</h1>")
          ..writeln('<p>https://${Constants.host}/organization/join/$refId</p>')
          ..writeln('<p>This link will expire in one week.</p>')
          ..writeln("<p>If you don't want to join the organization, you can ignore this email.</p>")
          ..writeln('<h2>$message</h2>')
          ..writeln('<p>Thanks,</p>')
          ..writeln('<p>${Constants.inviteEmailUserName}</p>'))
        .toString();

    final email = Message()
      ..from = Address(
        Constants.inviteEmailAccount,
        Constants.inviteEmailUserName,
      )
      ..recipients.add(to)
      ..subject = subject
      ..html = htmlMessage;

    try {
      return await retry<bool>(
        () {
          connection.send(email);
          return true;
        },
        maxAttempts: 3,
      );
    } catch (_) {
      return false;
    }
  }

  FutureOr<bool> sendRegisterVerificationEmail({
    required String to,
    required String activationKey,
  }) async {
    final subject = 'Activate Your WeAppe.ar Account';
    final htmlMessage = (StringBuffer()
          ..writeln("<h1>Here's your activation link:</h1>")
          ..writeln('<p>https://${Constants.host}/user/activate/$activationKey</p>')
          ..writeln('<p>This link will expire in one week.</p>')
          ..writeln("<p>If you don't want to activate this account, you can ignore this email.</p>")
          ..writeln('<p>Thanks,</p>')
          ..writeln('<p>${Constants.inviteEmailUserName}</p>'))
        .toString();

    final email = Message()
      ..from = Address(
        Constants.inviteEmailAccount,
        Constants.inviteEmailUserName,
      )
      ..recipients.add(to)
      ..subject = subject
      ..html = htmlMessage;

    try {
      return await retry<bool>(
        () {
          connection.send(email);
          return true;
        },
        maxAttempts: 3,
      );
    } catch (_) {
      return false;
    }
  }
}
