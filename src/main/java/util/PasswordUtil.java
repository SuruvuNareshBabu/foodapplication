package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    private PasswordUtil() {

    }

    // Encrypt Password
    public static String hashPassword(String password) {

        return BCrypt.hashpw(password, BCrypt.gensalt());

    }

    // Verify Password
    public static boolean verifyPassword(String password,
                                         String hashedPassword) {

        return BCrypt.checkpw(password, hashedPassword);

    }

}