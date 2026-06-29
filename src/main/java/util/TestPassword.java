package util;

public class TestPassword {

    public static void main(String[] args) {

        String password = "admin123";

        String encrypted =
                PasswordUtil.hashPassword(password);

        System.out.println("Encrypted Password");

        System.out.println(encrypted);

        System.out.println();

        boolean status =
                PasswordUtil.verifyPassword(
                        "admin123",
                        encrypted);

        System.out.println("Password Matched : " + status);

    }

}