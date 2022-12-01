import 'dart:async';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:retry/retry.dart';
import 'package:weappear_backend/src/models/organization/organization.dart';
import 'package:weappear_backend/src/models/user/user.dart';
import 'package:weappear_backend/src/utils/utils.dart';

class EmailSenderService {
  EmailSenderService() {
    try {
      smtpServer = SmtpServer(
        Constants.serverEmailHost,
        ssl: true,
        username: Constants.serverEmailAccount,
        password: Constants.serverEmailPassword,
        port: Constants.serverEmailPort,
      );

      from = Address(
        Constants.serverEmailAccount,
        Constants.serverEmailUserName,
      );

      connection = PersistentConnection(smtpServer);
    } catch (e) {
      print(e);
    }
  }

  late final SmtpServer smtpServer;
  late final Address from;
  late final PersistentConnection connection;

  FutureOr<bool> sendInvites({
    required List<User?> users,
    required Organization organization,
    required String refId,
  }) async {
    try {
      Future.wait(users.map((user) async {
        if (user != null) {
          final subject =
              'Invitation to join the ${organization.name} organization';
          final htmlMessage = (StringBuffer()
                ..writeln("<h1>Here's your invite link:</h1>")
                ..writeln(
                    '<p>https://${Constants.host}/organizations/join/$refId/${user.id?.$oid}</p>')
                ..writeln('<p>This link will expire in one week.</p>')
                ..writeln(
                    "<p>If you don't want to join the organization, you can ignore this email.</p>")
                ..writeln('<p>Thanks,</p>')
                ..writeln('<p>${Constants.serverEmailUserName}</p>'))
              .toString();

          final email = Message()
            ..from = from
            ..recipients.add(user.email)
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
      }));
      return true;
    } catch (e) {}
    return false;
  }

  FutureOr<bool> sendRegisterVerificationEmail({
    required String to,
    required String activationKey,
  }) async {
    final subject = 'Activate Your WeAppe.ar Account';
    final htmlMessage = (StringBuffer()
          ..writeln("<h1>Here's your activation link:</h1>")
          ..writeln(
              '<p>https://${Constants.host}/user/activate/$activationKey</p>')
          ..writeln('<p>This link will expire in one week.</p>')
          ..writeln(
              "<p>If you don't want to activate this account, you can ignore this email.</p>")
          ..writeln('<p>Thanks,</p>')
          ..writeln('<p>${Constants.serverEmailUserName}</p>'))
        .toString();

    final email = Message()
      ..from = from
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
