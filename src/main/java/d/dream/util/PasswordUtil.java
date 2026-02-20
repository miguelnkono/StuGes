package d.dream.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Password hashing utility using PBKDF2-HMAC-SHA256.
 *
 * Uses only the Java standard library — zero extra JARs needed.
 * Stored format: "pbkdf2$<iterations>$<base64-salt>$<base64-hash>"
 *
 * To switch to BCrypt later, swap hash() and verify() bodies only;
 * all servlet and DAO code stays untouched.
 */
public final class PasswordUtil {

    private static final int ITERATIONS = 310_000;
    private static final int SALT_BYTES = 16;
    private static final int HASH_BYTES = 32;
    private static final String ALGO    = "PBKDF2WithHmacSHA256";
    private static final SecureRandom RNG = new SecureRandom();

    private PasswordUtil() {}

    public static String hash(String plaintext) {
        byte[] salt = new byte[SALT_BYTES];
        RNG.nextBytes(salt);
        byte[] hash = pbkdf2(plaintext.toCharArray(), salt, ITERATIONS, HASH_BYTES);
        return "pbkdf2$" + ITERATIONS
                + "$" + Base64.getEncoder().encodeToString(salt)
                + "$" + Base64.getEncoder().encodeToString(hash);
    }

    public static boolean verify(String plaintext, String stored) {
        if (stored == null || !stored.startsWith("pbkdf2$")) return false;
        String[] parts = stored.split("\\$");
        if (parts.length != 4) return false;
        try {
            int    iters    = Integer.parseInt(parts[1]);
            byte[] salt     = Base64.getDecoder().decode(parts[2]);
            byte[] expected = Base64.getDecoder().decode(parts[3]);
            byte[] actual   = pbkdf2(plaintext.toCharArray(), salt, iters, expected.length);
            return MessageDigest.isEqual(expected, actual);
        } catch (Exception e) {
            return false;
        }
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int bytes) {
        try {
            javax.crypto.spec.PBEKeySpec spec =
                new javax.crypto.spec.PBEKeySpec(password, salt, iterations, bytes * 8);
            javax.crypto.SecretKeyFactory skf =
                javax.crypto.SecretKeyFactory.getInstance(ALGO);
            return skf.generateSecret(spec).getEncoded();
        } catch (Exception e) {
            throw new RuntimeException("PBKDF2 unavailable", e);
        }
    }
}
