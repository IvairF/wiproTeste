using System;
using System.Configuration;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Amil.AsmWebCad.Utils
{
    public static class PassEncryption
    {

        public static readonly int KeyLengthBits = 256;
        public static readonly int SaltLength = 8;
        private static readonly RNGCryptoServiceProvider Rng = new RNGCryptoServiceProvider();
        public static readonly string _encryptionkey = ConfigurationManager.AppSettings.Get("CriptoCode");


        public static string DecryptString(string ciphertext)
        {
            string criptoCode = ConfigurationManager.AppSettings.Get("CriptoCode");
            var inputs = ciphertext.Split(":".ToCharArray());
            var iv = Convert.FromBase64String(inputs[0]);
            var salt = Convert.FromBase64String(inputs[1]);
            var ciphertextBytes = Convert.FromBase64String(inputs[2]);
            var key = DeriveKeyFromPassphrase(criptoCode, salt);
            var plaintext = DoCryptoOperation(ciphertextBytes, key, iv, false);
            return Encoding.UTF8.GetString(plaintext);
        }

        public static string EncryptString(string plaintext)
        {
            string criptoCode = ConfigurationManager.AppSettings.Get("CriptoCode");
            var salt = GenerateRandomBytes(SaltLength);
            var iv = GenerateRandomBytes(16);
            var key = DeriveKeyFromPassphrase(criptoCode, salt);
            var ciphertext = DoCryptoOperation(Encoding.UTF8.GetBytes(plaintext), key, iv, true);
            return string.Format("{0}:{1}:{2}", Convert.ToBase64String(iv), Convert.ToBase64String(salt), Convert.ToBase64String(ciphertext));
        }

        private static byte[] DeriveKeyFromPassphrase(string passphrase, byte[] salt, int iterationCount = 100000)
        {
            var keyDerivationFunction = new Rfc2898DeriveBytes(passphrase, salt, iterationCount);
            return keyDerivationFunction.GetBytes(KeyLengthBits / 8);
        }

        private static byte[] GenerateRandomBytes(int lengthBytes)
        {
            var bytes = new byte[lengthBytes];
            Rng.GetBytes(bytes);
            return bytes;
        }

        private static byte[] DoCryptoOperation(byte[] inputData, byte[] key, byte[] iv, bool encrypt)
        {
            byte[] output;
            using (var aes = new AesCryptoServiceProvider())
            using (var ms = new MemoryStream())
            {
                var cryptoTransform = encrypt ? aes.CreateEncryptor(key, iv) : aes.CreateDecryptor(key, iv);
                using (var cs = new CryptoStream(ms, cryptoTransform, CryptoStreamMode.Write))
                    cs.Write(inputData, 0, inputData.Length);
                output = ms.ToArray();
            }
            return output;
        }

        public static string EncryptData(string textData, string Encryptionkey)
        {
            RijndaelManaged objrij = new RijndaelManaged();
            //iniciar o modo de operação
            objrij.Mode = CipherMode.CBC;
            //setar o padding de operação da string
            objrij.Padding = PaddingMode.PKCS7;
            //setar o tamanho (em bits) da operação 
            objrij.KeySize = 0x80;
            //setar o tamanho do bloco    
            objrij.BlockSize = 0x80;
            //setar a chave de criptografia
            byte[] passBytes = Encoding.UTF8.GetBytes(Encryptionkey);
            //setar o vetor de bytes de inicialização para criptografia
            byte[] EncryptionkeyBytes = new byte[] { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

            int len = passBytes.Length;
            if (len > EncryptionkeyBytes.Length)
            {
                len = EncryptionkeyBytes.Length;
            }
            Array.Copy(passBytes, EncryptionkeyBytes, len);

            objrij.Key = EncryptionkeyBytes;
            objrij.IV = EncryptionkeyBytes;

            //Cria uma chave simétrica
            ICryptoTransform objtransform = objrij.CreateEncryptor();
            byte[] textDataByte = Encoding.UTF8.GetBytes(textData);
            //Converte para string e retorna
            return Convert.ToBase64String(objtransform.TransformFinalBlock(textDataByte, 0, textDataByte.Length));
        }


        public static string DecryptData(string EncryptedText, string Encryptionkey)
        {
            RijndaelManaged objrij = new RijndaelManaged();
            objrij.Mode = CipherMode.CBC;
            objrij.Padding = PaddingMode.PKCS7;

            objrij.KeySize = 0x80;
            objrij.BlockSize = 0x80;
            byte[] encryptedTextByte = Convert.FromBase64String(EncryptedText);
            byte[] passBytes = Encoding.UTF8.GetBytes(Encryptionkey);
            byte[] EncryptionkeyBytes = new byte[0x10];
            int len = passBytes.Length;
            if (len > EncryptionkeyBytes.Length)
            {
                len = EncryptionkeyBytes.Length;
            }
            Array.Copy(passBytes, EncryptionkeyBytes, len);
            objrij.Key = EncryptionkeyBytes;
            objrij.IV = EncryptionkeyBytes;
            byte[] TextByte = objrij.CreateDecryptor().TransformFinalBlock(encryptedTextByte, 0, encryptedTextByte.Length);
            return Encoding.UTF8.GetString(TextByte);  //irá retornar a string original descriptografada
        }
    }
}