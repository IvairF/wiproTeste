using System;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Runtime.Serialization.Formatters.Binary;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;

namespace Amil.AppHospitais.Servicos.Util
{
    public class Conversores
    {
        private static string Formatacao(Conversores.FormatoData formato)
        {
            switch (formato)
            {
                case Conversores.FormatoData.dd_MM_yyyy:
                    return "dd/MM/yyyy";
                case Conversores.FormatoData.HH_mm:
                    return "HH:mm";
                case Conversores.FormatoData.dd_MM_yyyy_H_HH_mm:
                    return "dd/MM/yyyy\"H\"HH:mm";
                default:
                    return string.Empty;
            }
        }

        public static int ToIntDef(string str, int valorDefault)
        {
            int result;
            return int.TryParse(str, out result) ? result : valorDefault;
        }

        public static DateTime ConverteStringParaData(string value, CultureInfo cultura, Conversores.FormatoData Formato)
        {
            DateTime dateTime = DateTime.MinValue;
            return DateTime.ParseExact(value, Conversores.Formatacao(Formato), (IFormatProvider)cultura.DateTimeFormat);
        }

        public static DateTime ConverteStringParaData(string value, Conversores.FormatoData Formato)
        {
            CultureInfo cultura = new CultureInfo("pt-br");
            return Conversores.ConverteStringParaData(value, cultura, Formato);
        }

        public static string ConvertDataParaString(DateTime value, CultureInfo cultura, Conversores.FormatoData Formato)
        {
            return value.ToString(Conversores.Formatacao(Formato), (IFormatProvider)cultura.DateTimeFormat);
        }

        public static string ConvertDataParaString(DateTime value, Conversores.FormatoData Formato)
        {
            CultureInfo cultureInfo = new CultureInfo("pt-br");
            return value.ToString(Conversores.Formatacao(Formato), (IFormatProvider)cultureInfo.DateTimeFormat);
        }

        public static string ByteArrayToHexString(byte[] ba)
        {
            if (ba == null || ba.Length == 0)
                return "";
            string format = "{0:X2}";
            string str = "";
            foreach (byte num in ba)
                str = str + string.Format(format, (object)num);
            return str;
        }

        public static byte[] ObjectToByteArray(object obj)
        {
            byte[] numArray = (byte[])null;
            MemoryStream memoryStream = new MemoryStream();
            BinaryFormatter binaryFormatter = new BinaryFormatter();
            try
            {
                binaryFormatter.Serialize((Stream)memoryStream, obj);
                numArray = memoryStream.ToArray();
            }
            finally
            {
                memoryStream.Close();
            }
            return numArray;
        }

        public static object ByteArrayToObject(byte[] Buffer)
        {
            object obj = (object)null;
            BinaryFormatter binaryFormatter = new BinaryFormatter();
            MemoryStream memoryStream = new MemoryStream(Buffer);
            try
            {
                obj = binaryFormatter.Deserialize((Stream)memoryStream);
            }
            finally
            {
                memoryStream.Close();
            }
            return obj;
        }

        public enum FormatoData
        {
            dd_MM_yyyy,
            HH_mm,
            dd_MM_yyyy_H_HH_mm,
        }
    }

    public class SerializaMensagemTiss
    {
        private static Encoding enc = Encoding.GetEncoding("iso-8859-1");
        private string HashXML;
        private string CalculatedHash;
        private bool xmlValidoREV_A;
        private bool xmlValidoREV_B;
        private StringBuilder _xmlErrorMsg;
        private StringBuilder _xmlErrorMsgREV_A;
        private StringBuilder _xmlErrorMsgREV_B;

        static SerializaMensagemTiss()
        {
        }

        public static string calculaHash(string FileToCalc)
        {
            MD5CryptoServiceProvider cryptoServiceProvider = new MD5CryptoServiceProvider();
            Regex regex = new Regex("\\<[^\\>]*\\>", RegexOptions.IgnoreCase | RegexOptions.Multiline);
            StreamReader streamReader = new StreamReader(FileToCalc, SerializaMensagemTiss.enc);
            try
            {
                string input;
                while ((input = streamReader.ReadLine()) != null)
                {
                    string s1 = regex.Replace(input, "").TrimStart(new char[1]
          {
            ' '
          });
                    if (s1 != "")
                    {
                        if (!(s1 == "HASHCODEXMLSANSPADRAO"))
                        {
                            string s2 = HttpUtility.HtmlDecode(s1);
                            cryptoServiceProvider.TransformBlock(SerializaMensagemTiss.enc.GetBytes(s2), 0, s2.Length, (byte[])null, 0);
                        }
                        else
                            break;
                    }
                }
            }
            finally
            {
                streamReader.Close();
            }
            cryptoServiceProvider.TransformFinalBlock(SerializaMensagemTiss.enc.GetBytes(""), 0, 0);
            return Conversores.ByteArrayToHexString(cryptoServiceProvider.Hash);
        }

        public static string calculaHash(Stream StreamToCalc)
        {
            MD5CryptoServiceProvider cryptoServiceProvider = new MD5CryptoServiceProvider();
            Regex regex = new Regex("\\<[^\\>]*\\>", RegexOptions.IgnoreCase | RegexOptions.Multiline);
            StreamReader streamReader = new StreamReader(StreamToCalc, SerializaMensagemTiss.enc);
            try
            {
                string input;
                while ((input = streamReader.ReadLine()) != null)
                {
                    string s1 = regex.Replace(input, "").TrimStart(new char[1]
          {
            ' '
          });
                    if (s1 != "")
                    {
                        if (!(s1 == "HASHCODEXMLSANSPADRAO"))
                        {
                            string s2 = HttpUtility.HtmlDecode(s1);
                            cryptoServiceProvider.TransformBlock(SerializaMensagemTiss.enc.GetBytes(s2), 0, s2.Length, (byte[])null, 0);
                        }
                        else
                            break;
                    }
                }
            }
            finally
            {
                streamReader.Close();
            }
            cryptoServiceProvider.TransformFinalBlock(SerializaMensagemTiss.enc.GetBytes(""), 0, 0);
            return Conversores.ByteArrayToHexString(cryptoServiceProvider.Hash);
        }

        public static void XmlFileToCompressedFile(string InFile, string OutFile, string key)
        {
            FileStream fileStream1 = new FileStream(Path.ChangeExtension(OutFile, "tmp"), FileMode.Create, FileAccess.ReadWrite);
            GZipStream gzipStream = new GZipStream((Stream)fileStream1, CompressionMode.Compress, true);
            byte[] buffer = new byte[4096];
            BinaryReader binaryReader = new BinaryReader((Stream)new FileStream(InFile, FileMode.Open, FileAccess.Read));
            while (true)
            {
                int count = binaryReader.Read(buffer, 0, buffer.Length);
                if (count != 0)
                    gzipStream.Write(buffer, 0, count);
                else
                    break;
            }
            binaryReader.Close();
            gzipStream.Flush();
            gzipStream.Close();
            fileStream1.Position = 0L;
            FileStream fileStream2 = new FileStream(OutFile, FileMode.Create, FileAccess.Write);
            Rijndael cryptoServiceProvider = Rijndael.Create();
            cryptoServiceProvider.Key = Encoding.ASCII.GetBytes(key);
            cryptoServiceProvider.IV = Encoding.ASCII.GetBytes(key);
            CryptoStream cryptoStream = new CryptoStream((Stream)fileStream2, cryptoServiceProvider.CreateEncryptor(), CryptoStreamMode.Write);
            while (true)
            {
                int count = fileStream1.Read(buffer, 0, buffer.Length);
                if (count != 0)
                    cryptoStream.Write(buffer, 0, count);
                else
                    break;
            }
            fileStream1.Close();
            cryptoStream.Flush();
            fileStream2.Flush();
            cryptoStream.Close();
            fileStream2.Close();
            File.Delete(Path.ChangeExtension(OutFile, "tmp"));
        }

        public static string DeflateDecryptFile(string inFile, string NewFileName, string key)
        {
            return SerializaMensagemTiss.DeflateDecryptFile(inFile, Path.GetDirectoryName(NewFileName), Path.GetFileName(NewFileName), key, false);
        }

        public static string DeflateDecryptFile(string inFile, string outputDir, string key, bool deleteOriginalFile)
        {
            return SerializaMensagemTiss.DeflateDecryptFile(inFile, outputDir, (string)null, key, deleteOriginalFile);
        }

        public static string DescriptografaArquivoString(string inFile, string key, Encoding encoding)
        {
            return SerializaMensagemTiss.DescriptografaArquivoString(inFile, key, encoding, (Trace)null);
        }

        public static string DescriptografaArquivoString(string inFile, string key, Encoding encoding, Trace tr)
        {
            FileStream fileStream = new FileStream(inFile, FileMode.Open, FileAccess.Read);
            Rijndael cryptoServiceProvider = Rijndael.Create();
            cryptoServiceProvider.Key = Encoding.ASCII.GetBytes(key);
            cryptoServiceProvider.IV = Encoding.ASCII.GetBytes(key);
            CryptoStream cryptoStream = new CryptoStream((Stream)fileStream, cryptoServiceProvider.CreateDecryptor(), CryptoStreamMode.Read);
            byte[] numArray = new byte[4096];
            string str = string.Empty;
            Stream stream = (Stream)null;
            try
            {
                stream = (Stream)new GZipStream((Stream)cryptoStream, CompressionMode.Decompress, false);
                str = new StreamReader(stream).ReadToEnd();
            }
            finally
            {
                stream.Close();
                //if (tr == null)
                //  ;
            }
            return str;
        }

        public static string DeflateDecryptFile(string inFile, string outputDir, string NewFileName, string key, bool deleteOriginalFile)
        {
            string path = "";
            FileStream fileStream1 = new FileStream(inFile, FileMode.Open, FileAccess.Read);
            Rijndael cryptoServiceProvider = Rijndael.Create();
            cryptoServiceProvider.Key = Encoding.ASCII.GetBytes(key);
            cryptoServiceProvider.IV = Encoding.ASCII.GetBytes(key);
            CryptoStream cryptoStream = new CryptoStream((Stream)fileStream1, cryptoServiceProvider.CreateDecryptor(), CryptoStreamMode.Read);
            BinaryReader binaryReader = new BinaryReader((Stream)cryptoStream);
            FileStream fileStream2 = (FileStream)null;
            try
            {
                byte[] buffer = new byte[4096];
                fileStream2 = File.Create(Path.ChangeExtension(inFile, "tmp"));
                while (true)
                {
                    int count = binaryReader.Read(buffer, 0, buffer.Length);
                    if (count > 0)
                        fileStream2.Write(buffer, 0, count);
                    else
                        break;
                }
            }
            finally
            {
                binaryReader.Close();
                cryptoStream.Close();
                fileStream1.Close();
            }
            Stream stream = (Stream)null;
            FileStream fileStream3 = (FileStream)null;
            try
            {
                fileStream2.Flush();
                fileStream2.Position = 0L;
                stream = (Stream)new GZipStream((Stream)fileStream2, CompressionMode.Decompress, false);
                byte[] buffer = new byte[4096];
                path = NewFileName != null && !(NewFileName == string.Empty) ? Path.Combine(outputDir, NewFileName) : Path.Combine(outputDir, Path.GetFileName(Path.ChangeExtension(inFile, "xml")));
                fileStream3 = File.Create(path);
                int count = stream.Read(buffer, 0, buffer.Length);
                while (true)
                {
                    if (count == 0)
                        count = stream.Read(buffer, 0, buffer.Length);
                    if (count != 0)
                    {
                        fileStream3.Write(buffer, 0, count);
                        count = 0;
                    }
                    else
                        break;
                }
                stream.Flush();
                fileStream3.Flush();
            }
            finally
            {
                fileStream2.Close();
                stream.Close();
                fileStream3.Close();
            }
            File.Delete(Path.ChangeExtension(inFile, "tmp"));
            if (deleteOriginalFile)
                File.Delete(inFile);
            return Path.GetFileName(path);
        }

        public static MemoryStream DeflateDecryptFileToMemoryStream(string inFile, string key)
        {
            FileStream fileStream = new FileStream(inFile, FileMode.Open, FileAccess.Read);
            Rijndael cryptoServiceProvider = Rijndael.Create();
            cryptoServiceProvider.Key = Encoding.ASCII.GetBytes(key);
            cryptoServiceProvider.IV = Encoding.ASCII.GetBytes(key);
            CryptoStream cryptoStream = new CryptoStream((Stream)fileStream, cryptoServiceProvider.CreateDecryptor(), CryptoStreamMode.Read);
            BinaryReader binaryReader = new BinaryReader((Stream)cryptoStream);
            MemoryStream memoryStream1 = (MemoryStream)null;
            try
            {
                byte[] buffer = new byte[4096];
                memoryStream1 = new MemoryStream();
                while (true)
                {
                    int count = binaryReader.Read(buffer, 0, buffer.Length);
                    if (count > 0)
                        memoryStream1.Write(buffer, 0, count);
                    else
                        break;
                }
            }
            finally
            {
                binaryReader.Close();
                cryptoStream.Close();
                fileStream.Close();
            }
            Stream stream = (Stream)null;
            MemoryStream memoryStream2 = (MemoryStream)null;
            try
            {
                memoryStream1.Flush();
                memoryStream1.Position = 0L;
                stream = (Stream)new GZipStream((Stream)memoryStream1, CompressionMode.Decompress, false);
                byte[] buffer = new byte[4096];
                memoryStream2 = new MemoryStream();
                int count = stream.Read(buffer, 0, buffer.Length);
                while (true)
                {
                    if (count == 0)
                        count = stream.Read(buffer, 0, buffer.Length);
                    if (count != 0)
                    {
                        memoryStream2.Write(buffer, 0, count);
                        count = 0;
                    }
                    else
                        break;
                }
                stream.Flush();
                memoryStream2.Flush();
            }
            finally
            {
                memoryStream1.Close();
                stream.Close();
            }
            return memoryStream2;
        }

        public static string ToXmlString(object objToXml, Formatting formatacao, string encoding)
        {
            return Encoding.GetEncoding(encoding).GetString(SerializaMensagemTiss.ToXmlByteArray(objToXml, formatacao));
        }

        public static byte[] ToXmlByteArray(object objToXml, Formatting formatacao)
        {
            int flag = 0;
            if (objToXml == null)
                throw new ArgumentNullException("A mensagem não pode ser nula.");
            tissXmlWriter tissXmlWriter = (tissXmlWriter)null;
            try
            {
                MemoryStream memoryStream = new MemoryStream();
                XmlSerializer xmlSerializer = new XmlSerializer(objToXml.GetType());
                tissXmlWriter = new tissXmlWriter((Stream)memoryStream, SerializaMensagemTiss.enc, formatacao);
                XmlSerializerNamespaces namespaces = new XmlSerializerNamespaces();
                namespaces.Add("ans", "http://www.ans.gov.br/padroes/tiss/schemas");
                xmlSerializer.Serialize((XmlWriter)tissXmlWriter, objToXml, namespaces);
                tissXmlWriter.Flush();
                tissXmlWriter.Close();
                tissXmlWriter = (tissXmlWriter)null;

                return memoryStream.ToArray();
            }
            catch (Exception ex)
            {
                throw new ApplicationException("#1 Falha na geração da mensagem Tiss. Erro:" + ex.InnerException.Message, ex);
            }
            finally
            {
                if (tissXmlWriter != null)
                    tissXmlWriter.Close();
            }
        }

        public static MemoryStream ToXmlMemoryStream(object objToXml, Formatting formatacao)
        {
            MemoryStream memoryStream = new MemoryStream();
            try
            {
                XmlSerializer xmlSerializer = new XmlSerializer(objToXml.GetType());
                tissXmlWriter tissXmlWriter = new tissXmlWriter((Stream)memoryStream, SerializaMensagemTiss.enc, formatacao);
                XmlSerializerNamespaces namespaces = new XmlSerializerNamespaces();
                namespaces.Add("ans", "http://www.ans.gov.br/padroes/tiss/schemas");
                xmlSerializer.Serialize((XmlWriter)tissXmlWriter, objToXml, namespaces);
                return memoryStream;
            }
            catch (Exception ex)
            {
                throw new ApplicationException("#2 Falha na geração da mensagem Tiss." + ex.Message, ex);
            }
        }

        public static object FromCompressedXmlFile(Type TipoObjeto, string Arquivo, string key)
        {
            return SerializaMensagemTiss.deSerializa(TipoObjeto, SerializaMensagemTiss.LoadXmlToMemory(Arquivo, key).ToArray());
        }

        public static string NodeValue(string FromXml, string Node)
        {
            return SerializaMensagemTiss.NodeValue(FromXml, Node, false);
        }

        public static string NodeValue(string FromXml, string Node, bool OpenExclusive)
        {
            XmlReader xmlReader = (XmlReader)null;
            FileStream fileStream = (FileStream)null;
            try
            {

                
                if (OpenExclusive)
                {
                    XmlReaderSettings settings = new XmlReaderSettings();
                    settings.ValidationType = ValidationType.Schema;
                    
                    fileStream = File.Open(FromXml, FileMode.Open, FileAccess.Read, FileShare.None);
                    xmlReader = XmlReader.Create((Stream)fileStream, settings);
                }
                else
                    xmlReader = XmlReader.Create(FromXml);
                bool flag = false;
                while (xmlReader.Read())
                {
                    if (xmlReader.NodeType == XmlNodeType.Element && xmlReader.LocalName.ToLower() == Node.ToLower())
                    {
                        flag = true;
                        break;
                    }
                }
                if (!flag)
                    return (string)null;
                else
                    return xmlReader.ReadOuterXml();
            }
            finally
            {
                if (fileStream != null)
                    fileStream.Close();
                if (xmlReader != null)
                    xmlReader.Close();
            }
        }

        public static string GetNodeValue(string Mensagem, string Node)
        {
            XmlReader xmlReader = (XmlReader)null;
            try
            {
                XmlReaderSettings settings = new XmlReaderSettings();
                settings.ValidationType = ValidationType.Schema;        

                xmlReader = XmlReader.Create((Stream)new MemoryStream(Encoding.GetEncoding("iso-8859-1").GetBytes(Mensagem)), settings);
                bool flag = false;
                while (xmlReader.Read())
                {
                    if (xmlReader.NodeType == XmlNodeType.Element && xmlReader.LocalName.ToLower() == Node.ToLower())
                    {
                        flag = true;
                        break;
                    }
                }
                if (!flag)
                    return (string)null;
                else
                    return xmlReader.ReadOuterXml();
            }
            finally
            {
                if (xmlReader != null)
                    xmlReader.Close();
            }
        }

        public static string NodeValue(string FromXml, string key, string Node)
        {
            MemoryStream memoryStream = SerializaMensagemTiss.LoadXmlToMemory(FromXml, key);
            XmlReader xmlReader = (XmlReader)null;
            try
            {
                XmlReaderSettings settings = new XmlReaderSettings();
                settings.ValidationType = ValidationType.Schema;       

                xmlReader = XmlReader.Create((Stream)memoryStream, settings);
                bool flag = false;
                while (xmlReader.Read())
                {
                    if (xmlReader.NodeType == XmlNodeType.Element && xmlReader.LocalName.ToLower() == Node.ToLower())
                    {
                        flag = true;
                        break;
                    }
                }
                if (!flag)
                    return (string)null;
                else
                    return xmlReader.ReadOuterXml();
            }
            finally
            {
                if (xmlReader != null)
                    xmlReader.Close();
            }
        }

        public static object deSerializaFromString(Type TipoObjeto, string fromMemory)
        {
            byte[] bytes = SerializaMensagemTiss.enc.GetBytes(fromMemory);
            return SerializaMensagemTiss.deSerializa(TipoObjeto, bytes);
        }

        public static object deSerializa(Type TipoObjeto, byte[] fromMemory)
        {
            object obj;
            try
            {
                XmlSerializer xmlSerializer = new XmlSerializer(TipoObjeto);
                XmlTextReader xmlTextReader = new XmlTextReader((Stream)new MemoryStream(fromMemory));
                obj = xmlSerializer.Deserialize((XmlReader)xmlTextReader);
                xmlTextReader.Close();
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Falha de carga na classe Tiss.", ex);
            }
            return obj;
        }

        public static void ToXmlCompressedFile(object objToXml, Formatting formatacao, string Arquivo, string key)
        {
            MemoryStream memoryStream = new MemoryStream();
            GZipStream gzipStream = new GZipStream((Stream)memoryStream, CompressionMode.Compress, true);
            byte[] buffer = SerializaMensagemTiss.ToXmlByteArray(objToXml, formatacao);
            gzipStream.Write(buffer, 0, buffer.Length);
            gzipStream.Flush();
            gzipStream.Close();
            FileStream fileStream = new FileStream(Arquivo, FileMode.Create, FileAccess.Write);
            Rijndael cryptoServiceProvider = Rijndael.Create();
            cryptoServiceProvider.Key = Encoding.ASCII.GetBytes(key);
            cryptoServiceProvider.IV = Encoding.ASCII.GetBytes(key);
            CryptoStream cryptoStream = new CryptoStream((Stream)fileStream, cryptoServiceProvider.CreateEncryptor(), CryptoStreamMode.Write);
            cryptoStream.Write(memoryStream.ToArray(), 0, (int)memoryStream.Length);
            cryptoStream.Flush();
            cryptoStream.Close();
            fileStream.Close();
        }

        public static void ToXml(object objToXml, string filePath)
        {
            SerializaMensagemTiss.ToXml(objToXml, filePath, Formatting.None, true, "");
        }

        public static void ToXml(object objToXml, string filePath, string comentarioAmil)
        {
            SerializaMensagemTiss.ToXml(objToXml, filePath, Formatting.None, true, comentarioAmil);
        }

        public static void ToXml(object objToXml, string filePath, Formatting formatacao)
        {
            SerializaMensagemTiss.ToXml(objToXml, filePath, formatacao, true, "");
        }

        public static void ToXml(object objToXml, string filePath, Formatting formatacao, string comentarioAmil)
        {
            SerializaMensagemTiss.ToXml(objToXml, filePath, formatacao, true, comentarioAmil);
        }

        public static void ToXml(object objToXml, string filePath, Formatting formatacao, bool CompatibilidadeTissNET)
        {
            SerializaMensagemTiss.ToXml(objToXml, filePath, formatacao, CompatibilidadeTissNET, "");
        }

        public static void ToXml(object objToXml, string filePath, Formatting formatacao, bool CompatibilidadeTissNET, string comentarioAmil)
        {
            SerializaMensagemTiss.ToXml(objToXml, filePath, formatacao, CompatibilidadeTissNET, comentarioAmil, false);
        }

        public static void ToXml(object objToXml, string filePath, Formatting formatacao, bool CompatibilidadeTissNET, string comentarioAmil, bool NomeComHash)
        {
            SerializaMensagemTiss.ToXml(objToXml, filePath, formatacao, CompatibilidadeTissNET, comentarioAmil, false, "");
        }

        public static void ToXml(object objToXml, string filePath, Formatting formatacao, bool CompatibilidadeTissNET, string comentarioAmil, bool NomeComHash, string prefix)
        {
            string str = "";
            tissXmlWriter tissXmlWriter = (tissXmlWriter)null;
            try
            {
                XmlSerializer xmlSerializer = new XmlSerializer(objToXml.GetType());
                tissXmlWriter = new tissXmlWriter(filePath, SerializaMensagemTiss.enc, formatacao, CompatibilidadeTissNET);
                tissXmlWriter.ComentarioAmil = comentarioAmil;
                XmlSerializerNamespaces namespaces = new XmlSerializerNamespaces();
                namespaces.Add(string.IsNullOrEmpty(prefix) ? "ans" : prefix, "http://www.ans.gov.br/padroes/tiss/schemas");
                xmlSerializer.Serialize((XmlWriter)tissXmlWriter, objToXml, namespaces);
                str = tissXmlWriter.HashArquivo;
            }
            catch (Exception ex)
            {
                throw new ApplicationException("#3 Falha na geração da mensagem Tiss." + ex.Message, ex);
            }
            finally
            {
                if (tissXmlWriter != null)
                    tissXmlWriter.Close();
            }
            if (!NomeComHash || !(str != ""))
                return;
            string destFileName = Path.GetDirectoryName(filePath) + (object)Path.DirectorySeparatorChar + Path.GetFileNameWithoutExtension(filePath) + "_" + str + Path.GetExtension(filePath);
            File.Copy(filePath, destFileName, true);
            File.Delete(filePath);
        }

        public static object deSerializa(Type TipoObjeto, string fromXML)
        {
            object obj;
            try
            {
                XmlSerializer xmlSerializer = new XmlSerializer(TipoObjeto);
                XmlTextReader xmlTextReader = new XmlTextReader(fromXML);
                obj = xmlSerializer.Deserialize((XmlReader)xmlTextReader);
                xmlTextReader.Close();
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Falha de carga na classe Tiss.", ex);
            }
            return obj;
        }

        public bool ValidateTissXML(string fromXML, string schemaFile, Encoding encode)
        {
            return this.ValidateTissXML(fromXML, schemaFile, encode, true);
        }

        public bool ValidateTissXML(MemoryStream XMLDATA, string schemaFile, Encoding encode)
        {
            string xmlhash1 = "";
            string hashcalc1 = "";
            XMLDATA.Position = 0L;
            bool flag1 = this.ValidateTissREV_A((Stream)XMLDATA, schemaFile, encode, out xmlhash1, out hashcalc1, false);
            this.HashXML = xmlhash1;
            this.CalculatedHash = hashcalc1;
            if (!flag1)
            {
                this._xmlErrorMsg = new StringBuilder();
                this._xmlErrorMsg.Append(((object)this._xmlErrorMsgREV_A).ToString());
                return false;
            }
            else
            {
                if (this.HashXML.ToUpper() == this.CalculatedHash.ToUpper())
                    return true;
                this._xmlErrorMsg = (StringBuilder)null;
                string xmlhash2 = "";
                string hashcalc2 = "";
                XMLDATA.Position = 0L;
                bool flag2 = this.ValidateTissREV_B((Stream)XMLDATA, schemaFile, encode, out xmlhash2, out hashcalc2, false);
                this.HashXML = xmlhash2;
                this.CalculatedHash = hashcalc2;
                if (!flag2)
                {
                    this._xmlErrorMsg = new StringBuilder();
                    this._xmlErrorMsg.Append(((object)this._xmlErrorMsgREV_B).ToString());
                }
                return flag2;
            }
        }

        public bool ValidateTissXML(string fromXML, string schemaFile, Encoding encode, string key)
        {
            return this.ValidateTissXML(fromXML, schemaFile, encode, true, key);
        }

        public bool ValidateTissXML(string fromXML, string schemaFile, Encoding encode, bool calcHashTrim)
        {
            string xmlhash1 = "";
            string hashcalc1 = "";
            bool flag1 = this.ValidateTissREV_A(fromXML, schemaFile, encode, out xmlhash1, out hashcalc1, calcHashTrim);
            this.HashXML = xmlhash1;
            this.CalculatedHash = hashcalc1;
            if (!flag1)
            {
                this._xmlErrorMsg = new StringBuilder();
                this._xmlErrorMsg.Append(((object)this._xmlErrorMsgREV_A).ToString());
                return false;
            }
            else
            {
                if (this.HashXML.ToUpper() == this.CalculatedHash.ToUpper())
                    return true;
                this._xmlErrorMsg = (StringBuilder)null;
                string xmlhash2 = "";
                string hashcalc2 = "";
                bool flag2 = this.ValidateTissREV_B(fromXML, schemaFile, encode, out xmlhash2, out hashcalc2, calcHashTrim);
                this.HashXML = xmlhash2;
                this.CalculatedHash = hashcalc2;
                if (!flag2)
                {
                    this._xmlErrorMsg = new StringBuilder();
                    this._xmlErrorMsg.Append(((object)this._xmlErrorMsgREV_B).ToString());
                }
                return flag2;
            }
        }

        public bool ValidateTissXML(string fromXML, string schemaFile, Encoding encode, bool calcHashTrim, string key)
        {
            MemoryStream memoryStream = SerializaMensagemTiss.LoadXmlToMemory(fromXML, key);
            string xmlhash1 = "";
            string hashcalc1 = "";
            memoryStream.Position = 0L;
            bool flag1 = this.ValidateTissREV_A((Stream)memoryStream, schemaFile, encode, out xmlhash1, out hashcalc1, calcHashTrim);
            this.HashXML = xmlhash1;
            this.CalculatedHash = hashcalc1;
            if (!flag1)
            {
                this._xmlErrorMsg = new StringBuilder();
                this._xmlErrorMsg.Append(((object)this._xmlErrorMsgREV_A).ToString());
                return false;
            }
            else
            {
                if (this.HashXML.ToUpper() == this.CalculatedHash.ToUpper())
                    return true;
                this._xmlErrorMsg = (StringBuilder)null;
                string xmlhash2 = "";
                string hashcalc2 = "";
                memoryStream.Position = 0L;
                bool flag2 = this.ValidateTissREV_B((Stream)memoryStream, schemaFile, encode, out xmlhash2, out hashcalc2, calcHashTrim);
                this.HashXML = xmlhash2;
                this.CalculatedHash = hashcalc2;
                if (!flag2)
                {
                    this._xmlErrorMsg = new StringBuilder();
                    this._xmlErrorMsg.Append(((object)this._xmlErrorMsgREV_B).ToString());
                }
                return flag2;
            }
        }

        public string GetErrorMessages()
        {
            if (this._xmlErrorMsg != null)
                return ((object)this._xmlErrorMsg).ToString();
            else
                return "";
        }

        public string getCalculatedHash()
        {
            return this.CalculatedHash.ToUpper();
        }

        public bool isValidHashCode()
        {
            return this.CalculatedHash.ToUpper() == this.HashXML.ToUpper();
        }

        private static MemoryStream LoadXmlToMemory(string Arquivo, string key)
        {
            FileStream fileStream = new FileStream(Arquivo, FileMode.Open, FileAccess.Read);
            Rijndael cryptoServiceProvider = Rijndael.Create();
            cryptoServiceProvider.Key = Encoding.ASCII.GetBytes(key);
            cryptoServiceProvider.IV = Encoding.ASCII.GetBytes(key);
            CryptoStream cryptoStream = new CryptoStream((Stream)fileStream, cryptoServiceProvider.CreateDecryptor(), CryptoStreamMode.Read);
            BinaryReader binaryReader = new BinaryReader((Stream)cryptoStream);
            byte[] buffer1 = new byte[4096];
            MemoryStream memoryStream1 = new MemoryStream();
            while (true)
            {
                int count = binaryReader.Read(buffer1, 0, buffer1.Length);
                if (count > 0)
                    memoryStream1.Write(buffer1, 0, count);
                else
                    break;
            }
            binaryReader.Close();
            cryptoStream.Close();
            fileStream.Close();
            memoryStream1.Flush();
            memoryStream1.Position = 0L;
            Stream stream = (Stream)new GZipStream((Stream)memoryStream1, CompressionMode.Decompress, false);
            byte[] buffer2 = new byte[4096];
            MemoryStream memoryStream2 = new MemoryStream();
            int count1 = stream.Read(buffer2, 0, buffer2.Length);
            while (true)
            {
                if (count1 == 0)
                    count1 = stream.Read(buffer2, 0, buffer2.Length);
                if (count1 != 0)
                {
                    memoryStream2.Write(buffer2, 0, count1);
                    count1 = 0;
                }
                else
                    break;
            }
            stream.Flush();
            stream.Close();
            memoryStream2.Position = 0L;
            return memoryStream2;
        }

        private string TraduzTipo(XmlSeverityType tipoFalha)
        {
            string str = "Erro";
            switch (tipoFalha)
            {
                case XmlSeverityType.Error:
                    str = "Erro";
                    break;
                case XmlSeverityType.Warning:
                    str = "Aviso";
                    break;
            }
            return str;
        }

        private bool ValidateTissREV_A(string fromXML, string schemaFile, Encoding encode, out string xmlhash, out string hashcalc, bool CalcHashTrim)
        {
            this.xmlValidoREV_A = true;
            xmlhash = "";
            hashcalc = "";
            bool flag = false;
            string contents = "";
            string path = "C:\\tmp\\trace_REVA.txt";
            XmlReader xmlReader = (XmlReader)null;
            MD5CryptoServiceProvider cryptoServiceProvider = (MD5CryptoServiceProvider)null;
            try
            {
                this._xmlErrorMsgREV_A = new StringBuilder();
                XmlReaderSettings settings = new XmlReaderSettings();
                settings.ValidationEventHandler += new ValidationEventHandler(this.settings_ValidationEventHandlerREV_A);
                settings.ValidationType = ValidationType.Schema;
                settings.ConformanceLevel = ConformanceLevel.Document;
                settings.Schemas.Add((string)null, XmlReader.Create(schemaFile));
                xmlReader = XmlReader.Create(fromXML, settings);
                cryptoServiceProvider = new MD5CryptoServiceProvider();
                while (xmlReader.Read())
                {
                    if (xmlReader.NodeType != XmlNodeType.EndElement && xmlReader.NodeType != XmlNodeType.Whitespace && (xmlReader.NodeType != XmlNodeType.Comment && xmlReader.NodeType != XmlNodeType.DocumentType) && (xmlReader.NodeType != XmlNodeType.None && xmlReader.NodeType != XmlNodeType.Notation) && xmlReader.NodeType != XmlNodeType.XmlDeclaration)
                    {
                        if (xmlReader.NodeType == XmlNodeType.Element && xmlReader.LocalName.ToLower() == "hash")
                        {
                            if (xmlReader.Read())
                            {
                                xmlhash = xmlReader.Value;
                                break;
                            }
                            else
                                break;
                        }
                        else if (xmlReader.NodeType != XmlNodeType.Element && (xmlReader.Value != "" && (xmlReader.NodeType == XmlNodeType.Text || xmlReader.NodeType == XmlNodeType.CDATA)))
                        {
                            string s = CalcHashTrim ? xmlReader.Value.Trim() : xmlReader.Value;
                            if (flag)
                                contents = contents + s;
                            cryptoServiceProvider.TransformBlock(encode.GetBytes(s), 0, s.Length, (byte[])null, 0);
                        }
                    }
                }
                cryptoServiceProvider.TransformFinalBlock(encode.GetBytes(""), 0, 0);
                if (flag)
                {
                    try
                    {
                        if (Directory.Exists(Path.GetDirectoryName(path)))
                            File.WriteAllText(path, contents);
                    }
                    catch
                    {
                    }
                }
                hashcalc = Conversores.ByteArrayToHexString(cryptoServiceProvider.Hash);
                if (this.xmlValidoREV_A)
                    Debug.WriteLine("Documento Valido!");
                else
                    Debug.WriteLine("Documento invalido!");
            }
            catch (XmlException ex)
            {
                this.xmlValidoREV_A = false;
                this._xmlErrorMsgREV_A.AppendLine(string.Format("{0},{1},{2} - {3}", (object)ex.LineNumber, (object)ex.LinePosition, (object)"Erro", (object)ex.Message.Replace(" no espaço para nome 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace(" in namespace 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace("http://www.ans.gov.br/padroes/tiss/schemas:", "").Replace("http://www.w3.org/2001/XMLSchema:", "")));
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Falha de validação da mensagem Tiss." + ex.Message, ex);
            }
            finally
            {
                if (cryptoServiceProvider != null)
                    cryptoServiceProvider.Clear();
                if (xmlReader != null)
                    xmlReader.Close();
            }
            return this.xmlValidoREV_A;
        }

        private void settings_ValidationEventHandlerREV_A(object sender, ValidationEventArgs e)
        {
            Debug.WriteLine("Erro de validacao: " + e.Message);
            this._xmlErrorMsgREV_A.AppendLine(string.Format("{0},{1},{2} - {3}", (object)e.Exception.LineNumber, (object)e.Exception.LinePosition, (object)this.TraduzTipo(e.Severity), (object)e.Message.Replace(" no espaço para nome 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace(" in namespace 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace("http://www.ans.gov.br/padroes/tiss/schemas:", "").Replace("http://www.w3.org/2001/XMLSchema:", "")));
            if (e.Severity != XmlSeverityType.Error)
                return;
            this.xmlValidoREV_A = false;
        }

        private bool ValidateTissREV_B(string fromXML, string schemaFile, Encoding encode, out string xmlhash, out string hashcalc, bool CalcHashTrim)
        {
            this.xmlValidoREV_B = true;
            xmlhash = "";
            hashcalc = "";
            XmlReader xmlReader = (XmlReader)null;
            MD5CryptoServiceProvider cryptoServiceProvider = (MD5CryptoServiceProvider)null;
            try
            {
                this._xmlErrorMsgREV_B = new StringBuilder();
                XmlReaderSettings settings = new XmlReaderSettings();
                settings.ValidationEventHandler += new ValidationEventHandler(this.reader_ValidationEventHandlerREV_B);
                settings.ValidationType = ValidationType.Schema;
                settings.ConformanceLevel = ConformanceLevel.Document;
                settings.Schemas.Add((string)null, XmlReader.Create(schemaFile));
                xmlReader = XmlReader.Create(fromXML, settings);
                cryptoServiceProvider = new MD5CryptoServiceProvider();
                while (xmlReader.Read())
                {
                    if (xmlReader.NodeType != XmlNodeType.EndElement && xmlReader.NodeType != XmlNodeType.Whitespace && (xmlReader.NodeType != XmlNodeType.Comment && xmlReader.NodeType != XmlNodeType.DocumentType) && (xmlReader.NodeType != XmlNodeType.None && xmlReader.NodeType != XmlNodeType.Notation) && xmlReader.NodeType != XmlNodeType.XmlDeclaration)
                    {
                        if (xmlReader.NodeType == XmlNodeType.Element && xmlReader.LocalName.ToLower() == "hash")
                        {
                            if (xmlReader.Read())
                            {
                                xmlhash = xmlReader.Value;
                                break;
                            }
                            else
                                break;
                        }
                        else if (xmlReader.NodeType != XmlNodeType.Element && (xmlReader.Value.Trim() != "" && (xmlReader.NodeType == XmlNodeType.Text || xmlReader.NodeType == XmlNodeType.CDATA)))
                        {
                            string s = CalcHashTrim ? xmlReader.Value.Trim() : xmlReader.Value;
                            cryptoServiceProvider.TransformBlock(encode.GetBytes(s), 0, s.Length, (byte[])null, 0);
                        }
                    }
                }
                cryptoServiceProvider.TransformFinalBlock(encode.GetBytes(""), 0, 0);
                hashcalc = Conversores.ByteArrayToHexString(cryptoServiceProvider.Hash);
                if (this.xmlValidoREV_B)
                    Debug.WriteLine("Documento Valido!");
                else
                    Debug.WriteLine("Documento invalido!");
            }
            catch (XmlException ex)
            {
                this.xmlValidoREV_B = false;
                this._xmlErrorMsgREV_B.AppendLine(string.Format("{0},{1},{2} - {3}", (object)ex.LineNumber, (object)ex.LinePosition, (object)"Erro", (object)ex.Message.Replace(" no espaço para nome 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace(" in namespace 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace("http://www.ans.gov.br/padroes/tiss/schemas:", "").Replace("http://www.w3.org/2001/XMLSchema:", "")));
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Falha de validação da mensagem Tiss." + ex.Message, ex);
            }
            finally
            {
                if (cryptoServiceProvider != null)
                    cryptoServiceProvider.Clear();
                if (xmlReader != null)
                    xmlReader.Close();
            }
            return this.xmlValidoREV_B;
        }

        private void reader_ValidationEventHandlerREV_B(object sender, ValidationEventArgs e)
        {
            Debug.WriteLine("Erro de validacao: " + e.Message);
            this._xmlErrorMsgREV_B.AppendLine(string.Format("{0},{1},{2} - {3}", (object)e.Exception.LineNumber, (object)e.Exception.LinePosition, (object)this.TraduzTipo(e.Severity), (object)e.Message.Replace(" no espaço para nome 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace(" in namespace 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace("http://www.ans.gov.br/padroes/tiss/schemas:", "").Replace("http://www.w3.org/2001/XMLSchema:", "")));
            if (e.Severity != XmlSeverityType.Error)
                return;
            this.xmlValidoREV_B = false;
        }

        private bool ValidateTissREV_A(Stream fromXML, string schemaFile, Encoding encode, out string xmlhash, out string hashcalc, bool CalcHashTrim)
        {
            this.xmlValidoREV_A = true;
            xmlhash = "";
            hashcalc = "";
            XmlReader xmlReader = (XmlReader)null;
            MD5CryptoServiceProvider cryptoServiceProvider = (MD5CryptoServiceProvider)null;
            try
            {
                this._xmlErrorMsgREV_A = new StringBuilder();
                XmlReaderSettings settings = new XmlReaderSettings();
                settings.ValidationEventHandler += new ValidationEventHandler(this.settings_ValidationEventHandlerREV_A);
                settings.ValidationType = ValidationType.Schema;
                settings.ConformanceLevel = ConformanceLevel.Document;
                settings.Schemas.Add((string)null, XmlReader.Create(schemaFile));
                xmlReader = XmlReader.Create(fromXML, settings);
                cryptoServiceProvider = new MD5CryptoServiceProvider();
                while (xmlReader.Read())
                {
                    if (xmlReader.NodeType != XmlNodeType.EndElement && xmlReader.NodeType != XmlNodeType.Whitespace && (xmlReader.NodeType != XmlNodeType.Comment && xmlReader.NodeType != XmlNodeType.DocumentType) && (xmlReader.NodeType != XmlNodeType.None && xmlReader.NodeType != XmlNodeType.Notation) && xmlReader.NodeType != XmlNodeType.XmlDeclaration)
                    {
                        if (xmlReader.NodeType == XmlNodeType.Element && xmlReader.LocalName.ToLower() == "hash")
                        {
                            if (xmlReader.Read())
                            {
                                xmlhash = xmlReader.Value;
                                break;
                            }
                            else
                                break;
                        }
                        else if (xmlReader.NodeType != XmlNodeType.Element && (xmlReader.Value.Trim() != "" && (xmlReader.NodeType == XmlNodeType.Text || xmlReader.NodeType == XmlNodeType.CDATA)))
                        {
                            string s = CalcHashTrim ? xmlReader.Value.Trim() : xmlReader.Value;
                            cryptoServiceProvider.TransformBlock(encode.GetBytes(s), 0, s.Length, (byte[])null, 0);
                        }
                    }
                }
                cryptoServiceProvider.TransformFinalBlock(encode.GetBytes(""), 0, 0);
                hashcalc = Conversores.ByteArrayToHexString(cryptoServiceProvider.Hash);
                if (this.xmlValidoREV_A)
                    Debug.WriteLine("Documento Valido!");
                else
                    Debug.WriteLine("Documento invalido!");
            }
            catch (XmlException ex)
            {
                this.xmlValidoREV_A = false;
                this._xmlErrorMsgREV_A.AppendLine(string.Format("{0},{1},{2} - {3}", (object)ex.LineNumber, (object)ex.LinePosition, (object)"Erro", (object)ex.Message.Replace(" no espaço para nome 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace(" in namespace 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace("http://www.ans.gov.br/padroes/tiss/schemas:", "").Replace("http://www.w3.org/2001/XMLSchema:", "")));
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Falha de validação da mensagem Tiss." + ex.Message, ex);
            }
            finally
            {
                if (cryptoServiceProvider != null)
                    cryptoServiceProvider.Clear();
                if (xmlReader != null)
                    xmlReader.Close();
            }
            return this.xmlValidoREV_A;
        }

        private bool ValidateTissREV_B(Stream fromXML, string schemaFile, Encoding encode, out string xmlhash, out string hashcalc, bool CalcHashTrim)
        {
            this.xmlValidoREV_B = true;
            xmlhash = "";
            hashcalc = "";
            XmlReader xmlReader = (XmlReader)null;
            MD5CryptoServiceProvider cryptoServiceProvider = (MD5CryptoServiceProvider)null;
            try
            {
                this._xmlErrorMsgREV_A = new StringBuilder();
                this._xmlErrorMsgREV_B = new StringBuilder();
                XmlReaderSettings settings = new XmlReaderSettings();
                settings.ValidationEventHandler += new ValidationEventHandler(this.reader_ValidationEventHandlerREV_B);
                settings.ValidationType = ValidationType.Schema;
                settings.ConformanceLevel = ConformanceLevel.Document;
                settings.Schemas.Add((string)null, XmlReader.Create(schemaFile));
                xmlReader = XmlReader.Create(fromXML, settings);
                cryptoServiceProvider = new MD5CryptoServiceProvider();
                while (xmlReader.Read())
                {
                    if (xmlReader.NodeType != XmlNodeType.EndElement && xmlReader.NodeType != XmlNodeType.Whitespace && (xmlReader.NodeType != XmlNodeType.Comment && xmlReader.NodeType != XmlNodeType.DocumentType) && (xmlReader.NodeType != XmlNodeType.None && xmlReader.NodeType != XmlNodeType.Notation) && xmlReader.NodeType != XmlNodeType.XmlDeclaration)
                    {
                        if (xmlReader.NodeType == XmlNodeType.Element && xmlReader.LocalName.ToLower() == "hash")
                        {
                            if (xmlReader.Read())
                            {
                                xmlhash = xmlReader.Value;
                                break;
                            }
                            else
                                break;
                        }
                        else if (xmlReader.NodeType != XmlNodeType.Element && (xmlReader.Value.Trim() != "" && (xmlReader.NodeType == XmlNodeType.Text || xmlReader.NodeType == XmlNodeType.CDATA)))
                        {
                            string s = CalcHashTrim ? xmlReader.Value.Trim() : xmlReader.Value;
                            cryptoServiceProvider.TransformBlock(encode.GetBytes(s), 0, s.Length, (byte[])null, 0);
                        }
                    }
                }
                cryptoServiceProvider.TransformFinalBlock(encode.GetBytes(""), 0, 0);
                hashcalc = Conversores.ByteArrayToHexString(cryptoServiceProvider.Hash);
                if (this.xmlValidoREV_B)
                    Debug.WriteLine("Documento Valido!");
                else
                    Debug.WriteLine("Documento invalido!");
            }
            catch (XmlException ex)
            {
                this.xmlValidoREV_B = false;
                this._xmlErrorMsgREV_B.AppendLine(string.Format("{0},{1},{2} - {3}", (object)ex.LineNumber, (object)ex.LinePosition, (object)"Erro", (object)ex.Message.Replace(" no espaço para nome 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace(" in namespace 'http://www.ans.gov.br/padroes/tiss/schemas'", "").Replace("http://www.ans.gov.br/padroes/tiss/schemas:", "").Replace("http://www.w3.org/2001/XMLSchema:", "")));
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Falha de validação da mensagem Tiss." + ex.Message, ex);
            }
            finally
            {
                if (cryptoServiceProvider != null)
                    cryptoServiceProvider.Clear();
                if (xmlReader != null)
                    xmlReader.Close();
            }
            return this.xmlValidoREV_B;
        }
    }
}