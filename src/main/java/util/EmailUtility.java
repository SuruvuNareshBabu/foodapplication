package util;

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
    
    // Configuration details
	private static final String SMTP_HOST = "sandbox.smtp.mailtrap.io";
	private static final String SMTP_PORT = "2525";
	private static final String SENDER_EMAIL = "27c3cc87755894";
	private static final String SENDER_APP_PASSWORD = "9b70cf845859a2";

    public static void sendEmail(String recipientEmail, String subject, String messageBody) {
        
        Properties properties = new Properties();
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        System.out.println("Attempting to send email to: " + recipientEmail);

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setText(messageBody);

            Transport.send(message);
            System.out.println("Success: Email dispatched to " + recipientEmail);
            
        } catch (MessagingException e) {
            System.err.println("Error: Failed to send email to " + recipientEmail);
            e.printStackTrace(); 
        }
    }
    
    public static void main(String[] args) {
        // Replace these with your actual test values
        String testEmail = "your_test_account@gmail.com";
        String testSubject = "Test Connection";
        String testBody = "If you receive this, your code is working!";
        
        System.out.println("Starting test...");
        sendEmail(testEmail, testSubject, testBody);
        System.out.println("Test finished. Check console for errors.");
    }
}