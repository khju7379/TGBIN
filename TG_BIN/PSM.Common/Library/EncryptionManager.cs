using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace PSM.Common.Library
{
    public class EncryptionManager
    {
        public static string DecryptString(string publicKey, string InputText)
        {
            try
            {
                string strPassword = publicKey;
                RijndaelManaged managed = new RijndaelManaged();
                byte[] buffer = Convert.FromBase64String(InputText);
                byte[] rgbSalt = Encoding.ASCII.GetBytes(strPassword.Length.ToString());
                PasswordDeriveBytes bytes = new PasswordDeriveBytes(strPassword, rgbSalt);
                ICryptoTransform transform = managed.CreateDecryptor(bytes.GetBytes(0x20), bytes.GetBytes(0x10));
                MemoryStream stream = new MemoryStream(buffer);
                CryptoStream stream2 = new CryptoStream(stream, transform, CryptoStreamMode.Read);
                byte[] buffer3 = new byte[buffer.Length];
                int count = stream2.Read(buffer3, 0, buffer3.Length);
                stream.Close();
                stream2.Close();
                return Encoding.Unicode.GetString(buffer3, 0, count);
            }
            catch
            {
                return "";
            }
        }

        public static string EncryptString(string publicKey, string InputText)
        {
            string strPassword = publicKey;
            RijndaelManaged managed = new RijndaelManaged();
            byte[] buffer = Encoding.Unicode.GetBytes(InputText);
            byte[] rgbSalt = Encoding.ASCII.GetBytes(strPassword.Length.ToString());
            PasswordDeriveBytes bytes = new PasswordDeriveBytes(strPassword, rgbSalt);
            ICryptoTransform transform = managed.CreateEncryptor(bytes.GetBytes(0x20), bytes.GetBytes(0x10));
            MemoryStream stream = new MemoryStream();
            CryptoStream stream2 = new CryptoStream(stream, transform, CryptoStreamMode.Write);
            stream2.Write(buffer, 0, buffer.Length);
            stream2.FlushFinalBlock();
            byte[] inArray = stream.ToArray();
            stream.Close();
            stream2.Close();
            return Convert.ToBase64String(inArray);
        }

        #region EncryptStringMD5 - 암호화
        /// <summary>
        /// Public Key를 이용하여 암호화 한 Input Text를 MD5로 암호 이중화 한다.
        /// 해당 암호는 복호화 불가능 하다.
        /// </summary>
        /// <param name="publicKey"></param>
        /// <param name="InputText"></param>
        /// <returns></returns>
        public static string EncryptStringMD5(string publicKey, string InputText)
        {
            string strPassword = publicKey;
            RijndaelManaged managed = new RijndaelManaged();
            byte[] buffer = Encoding.Unicode.GetBytes(InputText);
            byte[] rgbSalt = Encoding.ASCII.GetBytes(strPassword.Length.ToString());
            PasswordDeriveBytes bytes = new PasswordDeriveBytes(strPassword, rgbSalt);
            ICryptoTransform transform = managed.CreateEncryptor(bytes.GetBytes(0x20), bytes.GetBytes(0x10));
            MemoryStream stream = new MemoryStream();
            CryptoStream stream2 = new CryptoStream(stream, transform, CryptoStreamMode.Write);
            stream2.Write(buffer, 0, buffer.Length);
            stream2.FlushFinalBlock();
            byte[] inArray = stream.ToArray();
            stream.Close();
            stream2.Close();

            // MD5를 사용하여 암호의 이중화
            byte[] data = (MD5.Create().ComputeHash(inArray));

            StringBuilder sb = new StringBuilder();

            foreach (byte b in data)
            {
                sb.Append(b.ToString("x2"));
            }

            return sb.ToString();
        }
        #endregion

        /// <summary>  
        /// Decrypts a base64 encoded string using the given key (AES 128bit key and a Chain Block Cipher)  
        /// </summary>  
        /// <param name="encryptedText">Base64 Encoded String</param>  
        /// <param name="key">Secret Key</param>  
        /// <returns>Decrypted String</returns>  
        public static String DecryptBase64(string publicKey, string InputText)
        {
            return Decrypt(InputText, publicKey);
        }

        /// <summary>  
        /// Encrypts plaintext using AES 128bit key and a Chain Block Cipher and returns a base64 encoded string  
        /// </summary>  
        /// <param name="plainText">Plain text to encrypt</param>  
        /// <param name="key">Secret key</param>  
        /// <returns>Base64 encoded string</returns>  
        public static String EncryptBase64(string publicKey, string InputText)
        {
            return Encrypt(InputText, publicKey);
        }

        public static RijndaelManaged GetRijndaelManaged(String secretKey)
        {
            var keyBytes = new byte[16];
            var secretKeyBytes = Encoding.UTF8.GetBytes(secretKey);
            Array.Copy(secretKeyBytes, keyBytes, Math.Min(keyBytes.Length, secretKeyBytes.Length));
            return new RijndaelManaged
            {
                Mode = CipherMode.CBC,
                Padding = PaddingMode.PKCS7,
                KeySize = 128,
                BlockSize = 128,
                Key = keyBytes,
                IV = keyBytes
            };
        }

        public static byte[] Encrypt(byte[] plainBytes, RijndaelManaged rijndaelManaged)
        {
            return rijndaelManaged.CreateEncryptor()
                .TransformFinalBlock(plainBytes, 0, plainBytes.Length);
        }

        public static byte[] Decrypt(byte[] encryptedData, RijndaelManaged rijndaelManaged)
        {
            return rijndaelManaged.CreateDecryptor()
                .TransformFinalBlock(encryptedData, 0, encryptedData.Length);
        }

        /// <summary>  
        /// Encrypts plaintext using AES 128bit key and a Chain Block Cipher and returns a base64 encoded string  
        /// </summary>  
        /// <param name="plainText">Plain text to encrypt</param>  
        /// <param name="key">Secret key</param>  
        /// <returns>Base64 encoded string</returns>  
        public static String Encrypt(String plainText, String key)
        {
            var plainBytes = Encoding.UTF8.GetBytes(plainText);
            return Convert.ToBase64String(Encrypt(plainBytes, GetRijndaelManaged(key)));
        }

        /// <summary>  
        /// Decrypts a base64 encoded string using the given key (AES 128bit key and a Chain Block Cipher)  
        /// </summary>  
        /// <param name="encryptedText">Base64 Encoded String</param>  
        /// <param name="key">Secret Key</param>  
        /// <returns>Decrypted String</returns>  
        public static String Decrypt(String encryptedText, String key)
        {
            try
            {
                var encryptedBytes = Convert.FromBase64String(encryptedText);
                return Encoding.UTF8.GetString(Decrypt(encryptedBytes, GetRijndaelManaged(key)));
            }
            catch
            {
                return "";
            }
        }

        /***************************************************************************************
         * Mobile 겸용 암/복호화 모듈
         ***************************************************************************************/

        #region AES_encrypt -  AES 암호화 모듈 
        /// <summary>
        /// AES 암호화 모듈 
        /// </summary>
        /// <param name="Input"></param>
        /// <returns></returns>
        public static string AES_encrypt(string key, string Input)
        {
            //string key = "FFF00EB1E8E70E7F4C67B1D665324630";

            RijndaelManaged aes = new RijndaelManaged();
            aes.KeySize = 256;
            aes.BlockSize = 128;
            aes.Mode = CipherMode.CBC;
            aes.Padding = PaddingMode.PKCS7;
            aes.Key = Encoding.UTF8.GetBytes(key);
            aes.IV = new byte[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

            var encrypt = aes.CreateEncryptor(aes.Key, aes.IV);
            byte[] xBuff = null;
            using (var ms = new MemoryStream())
            {
                using (var cs = new CryptoStream(ms, encrypt, CryptoStreamMode.Write))
                {
                    byte[] xXml = Encoding.UTF8.GetBytes(Input);
                    cs.Write(xXml, 0, xXml.Length);
                }

                xBuff = ms.ToArray();
            }

            return Convert.ToBase64String(xBuff);
        }
        #endregion

        #region AES_decrypt - AES 복호화 모듈 
        /// <summary>
        /// AES 복호화 모듈 
        /// </summary>
        /// <param name="Input"></param>
        /// <returns></returns>
        public static string AES_decrypt(string key, string Input)
        {
            //string key = "FFF00EB1E8E70E7F4C67B1D665324630";

            RijndaelManaged aes = new RijndaelManaged();
            aes.KeySize = 256;
            aes.BlockSize = 128;
            aes.Mode = CipherMode.CBC;
            aes.Padding = PaddingMode.PKCS7;
            aes.Key = Encoding.UTF8.GetBytes(key);
            aes.IV = new byte[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

            var decrypt = aes.CreateDecryptor();
            byte[] xBuff = null;
            using (var ms = new MemoryStream())
            {
                using (var cs = new CryptoStream(ms, decrypt, CryptoStreamMode.Write))
                {
                    byte[] xXml = Convert.FromBase64String(Input);
                    cs.Write(xXml, 0, xXml.Length);
                }

                xBuff = ms.ToArray();
            }

            return Encoding.UTF8.GetString(xBuff);
        }
        #endregion

    }

    /***************************************************************************************
     * 멀티캠퍼스 암/복호화 모듈
     ***************************************************************************************/
    /// <summary>
    /// This class converts a UTF-8 string into a cipher string, and vice versa.
    /// It uses 128-bit AES Algorithm in Cipher Block Chaining (CBC) mode with a UTF-8 key
    /// string and a UTF-8 initial vector string which are hashed by MD5. PKCS7 Padding is used
    /// as a padding mode and binary output is encoded by Base64.
    /// </summary>
    public class StringEncrypter
    {
        private System.Text.UTF8Encoding utf8Encoding;
        private RijndaelManaged rijndael;


        /// <summary>
        /// Creates a StringEncrypter instance.
        /// </summary>
        /// <param name="key">A key string which is converted into UTF-8 and hashed by MD5.
        /// Null or an empty string is not allowed.</param>
        /// <param name="initialVector">An initial vector string which is converted into UTF-8
        /// and hashed by MD5. Null or an empty string is not allowed.</param>
        public StringEncrypter(string key, string initialVector)
        {
            if (key == null || key == "")
                throw new ArgumentException("The key can not be null or an empty string.", "key");

            if (initialVector == null || initialVector == "")
                throw new ArgumentException("The initial vector can not be null or an empty string.", "initialVector");



            // This is an encoder which converts a string into a UTF-8 byte array.
            this.utf8Encoding = new System.Text.UTF8Encoding();



            // Create a AES algorithm.
            this.rijndael = new RijndaelManaged();

            // Set cipher and padding mode.
            this.rijndael.Mode = CipherMode.CBC;
            this.rijndael.Padding = PaddingMode.PKCS7;

            // Set key and block size.
            const int chunkSize = 128;

            this.rijndael.KeySize = chunkSize;
            this.rijndael.BlockSize = chunkSize;

            // Initialize an encryption key and an initial vector.
            MD5 md5 = new MD5CryptoServiceProvider();
            this.rijndael.Key = md5.ComputeHash(this.utf8Encoding.GetBytes(key)); ;
            this.rijndael.IV = md5.ComputeHash(this.utf8Encoding.GetBytes(initialVector));
        }


        /// <summary>
        /// Encrypts a string.
        /// </summary>
        /// <param name="value">A string to encrypt. It is converted into UTF-8 before being encrypted.
        /// Null is regarded as an empty string.</param>
        /// <returns>An encrypted string.</returns>
        public string Encrypt(string value)
        {
            if (value == null)
                value = "";

            // Get an encryptor interface.
            ICryptoTransform transform = this.rijndael.CreateEncryptor();

            // Get a UTF-8 byte array from a unicode string.
            byte[] utf8Value = this.utf8Encoding.GetBytes(value);

            // Encrypt the UTF-8 byte array.
            byte[] encryptedValue = transform.TransformFinalBlock(utf8Value, 0, utf8Value.Length);

            // Return a base64 encoded string of the encrypted byte array.
            return Convert.ToBase64String(encryptedValue);
        }


        /// <summary>
        /// Decrypts a string which is encrypted with the same key and initial vector. 
        /// </summary>
        /// <param name="value">A string to decrypt. It must be a string encrypted with the same key and initial vector.
        /// Null or an empty string is not allowed.</param>
        /// <returns>A decrypted string</returns>
        public string Decrypt(string value)
        {
            if (value == null || value == "")
                throw new ArgumentException("The cipher string can not be null or an empty string.");

            value = System.Web.HttpUtility.UrlDecode(value);

            // Get an decryptor interface.
            ICryptoTransform transform = rijndael.CreateDecryptor();

            // Get an encrypted byte array from a base64 encoded string.
            byte[] encryptedValue = Convert.FromBase64String(value);

            // Decrypt the byte array.
            byte[] decryptedValue = transform.TransformFinalBlock(encryptedValue, 0, encryptedValue.Length);

            // Return a string converted from the UTF-8 byte array.
            return this.utf8Encoding.GetString(decryptedValue);
        }


    }
}
