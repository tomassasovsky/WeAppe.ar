import 'dart:async';

import 'package:base32/base32.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:ootp/ootp.dart';
import 'package:retry/retry.dart';
import 'package:weappear_backend/src/models/organization/organization.dart';
import 'package:weappear_backend/src/models/user/user.dart';
import 'package:weappear_backend/src/utils/utils.dart';

/// {@template email_sender_service}
/// This class has all the methods to send emails.
/// {@endtemplate}
class EmailSenderService {
  /// {@macro email_sender_service}
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
    } catch (_) {}
  }

  /// The smtp server.
  late final SmtpServer smtpServer;

  /// The address from which the emails will be sent.
  late final Address from;

  /// The connection to the smtp server.
  late final PersistentConnection connection;

  /// This method is in charge of sending invitation mails to join an organization.
  FutureOr<bool> sendInvites({
    required List<User?> users,
    required Organization organization,
    required String refId,
  }) async {
    try {
      await Future.wait(
        users.map((user) async {
          if (user != null) {
            final subject =
                'Invitation to join the ${organization.name} organization';
            final htmlMessage = (StringBuffer()
                  ..writeln("<h1>Here's your invite link:</h1>")
                  ..writeln(
                    '<p>https://${Constants.host}/organizations/join/$refId/${user.id?.$oid}</p>',
                  )
                  ..writeln('<p>This link will expire in one week.</p>')
                  ..writeln(
                    "<p>If you don't want to join the organization, you can ignore this email.</p>",
                  )
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
        }),
      );
      return true;
    } catch (_) {}
    return false;
  }

  /// This method is in charge of sending the email to verify the email address.
  FutureOr<bool> sendRegisterVerificationEmail({
    required String to,
    required String activationCode,
  }) async {
    const subject = 'Activate Your WeAppe.ar Account';
    final htmlMessage = HTMLS.getActivationCodeHTML(to, activationCode);

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

  /// Generates an OTP code for the user verification.
  static String createOtp() {
    final hotpSecret = Constants.hotpSecret;
    final encodedHOTPSecret = base32.decode(hotpSecret);
    final hotp = HOTP(encodedHOTPSecret);
    final totp = TOTP(hotp, period: 1);
    return totp.make();
  }
}
