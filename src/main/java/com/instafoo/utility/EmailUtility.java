package com.instafoo.utility;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtility {

    public static boolean sendOtpEmail(String toEmail, String otp) {
        // Legacy OTP sender (kept as fallback)
        System.out.println("SMTP (LOG ONLY): Verification OTP for " + toEmail + " is: " + otp);
        return false;
    }

    public static boolean sendMagicLinkEmail(String toEmail, String magicLink) {
        final String smtpHost = System.getenv("SMTP_HOST") != null ? System.getenv("SMTP_HOST") : "smtp.gmail.com";
        final String smtpPort = System.getenv("SMTP_PORT") != null ? System.getenv("SMTP_PORT") : "587";
        final String smtpUser = System.getenv("SMTP_USER");
        final String smtpPassword = System.getenv("SMTP_PASSWORD");

        System.out.println("DEBUG: Preparing to send Magic Link to " + toEmail);

        if (smtpUser == null || smtpUser.trim().isEmpty() || smtpPassword == null || smtpPassword.trim().isEmpty()) {
            System.out.println("WARNING: SMTP credentials (SMTP_USER/SMTP_PASSWORD) are not set. Email not sent.");
            System.out.println("SMTP (LOG ONLY): Click here to reset your password -> " + magicLink);
            return false;
        }

        Properties prop = new Properties();
        prop.put("mail.smtp.host", smtpHost);
        prop.put("mail.smtp.port", smtpPort);
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(prop, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(smtpUser, "Instafoods Security"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Reset Your Instafoods Password");
            
            String htmlContent = "<div style=\"font-family: 'Segoe UI', Arial, sans-serif; background-color: #0c0c0c; color: #ffffff; padding: 40px; border-radius: 16px; max-width: 500px; border: 1px solid rgba(255,255,255,0.08);\">"
                    + "<h2 style=\"color: #caff00; text-transform: uppercase; font-size: 1.5rem; letter-spacing: 0.5px; margin-bottom: 20px;\">Instafoods Security</h2>"
                    + "<p style=\"font-size: 0.95rem; line-height: 1.6; color: #e0e0e0;\">A request was made to reset your password or unlock your account. Click the button below to reset your password directly:</p>"
                    + "<div style=\"text-align: center; margin: 36px 0;\">"
                    + "<a href=\"" + magicLink + "\" style=\"background-color: #caff00; color: #000000; padding: 14px 32px; font-weight: 800; font-size: 0.95rem; text-decoration: none; border-radius: 8px; text-transform: uppercase; display: inline-block; box-shadow: 0 4px 20px rgba(202,255,0,0.3);\">Reset Password</a>"
                    + "</div>"
                    + "<p style=\"font-size: 0.82rem; color: #888; line-height: 1.5;\">This magic link will expire in 10 minutes. If the button above doesn't work, copy and paste this link into your browser:<br>"
                    + "<a href=\"" + magicLink + "\" style=\"color: #00e5ff; text-decoration: none;\">" + magicLink + "</a></p>"
                    + "<hr style=\"border: none; border-top: 1px solid rgba(255,255,255,0.08); margin: 30px 0;\">"
                    + "<p style=\"font-size: 0.78rem; color: #555;\">If you did not make this request, you can safely ignore this email.</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("SUCCESS: Magic Link email sent successfully to " + toEmail);
            return true;
        } catch (Exception e) {
            System.out.println("ERROR: Failed to send Magic Link email to " + toEmail + " due to exception: " + e.getMessage());
            e.printStackTrace();
            System.out.println("SMTP (FALLBACK LOG): Click here to reset your password -> " + magicLink);
            return false;
        }
    }
}
