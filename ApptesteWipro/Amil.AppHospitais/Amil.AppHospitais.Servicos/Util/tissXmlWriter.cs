using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Xml;

namespace Amil.AppHospitais.Servicos.Util
{
    internal class tissXmlWriter : XmlTextWriter
    {
        private bool attrwrt = false;
        protected Encoding encode;
        private MD5CryptoServiceProvider hash;
        private string _HashArquivo;
        private string _DebugConteudo;
        private string _DebugTraceFile;
        private string comentarioAmil;
        private bool _DebugON;
        private bool HashModoCompatibilidade;

        public string DebugConteudo
        {
            get
            {
                return this._DebugConteudo;
            }
        }

        public bool DebugON
        {
            get
            {
                return this._DebugON;
            }
            set
            {
                this._DebugON = value;
            }
        }

        public string DebugTraceFile
        {
            get
            {
                return this._DebugTraceFile;
            }
            set
            {
                this._DebugTraceFile = value;
            }
        }

        public string HashArquivo
        {
            get
            {
                return this._HashArquivo;
            }
        }

        public string ComentarioAmil
        {
            get
            {
                return this.comentarioAmil;
            }
            set
            {
                this.comentarioAmil = value;
            }
        }

        public tissXmlWriter(Stream sw, Encoding encoding)
            : base(sw, encoding)
        {
            this.encode = encoding;
            this.HashModoCompatibilidade = true;
            this.inicializavars();
        }

        public tissXmlWriter(Stream sw, Encoding encoding, Formatting formatacao)
            : base(sw, encoding)
        {
            this.Formatting = formatacao;
            this.encode = encoding;
            this.HashModoCompatibilidade = true;
            this.inicializavars();
        }

        public tissXmlWriter(string filePath, Encoding encoding)
            : base(filePath, encoding)
        {
            this.Formatting = Formatting.None;
            this.encode = encoding;
            this.HashModoCompatibilidade = true;
            this.inicializavars();
        }

        public tissXmlWriter(string filePath, Encoding encoding, Formatting formatacao)
            : base(filePath, encoding)
        {
            this.Formatting = formatacao;
            this.encode = encoding;
            this.HashModoCompatibilidade = true;
            this.inicializavars();
        }

        public tissXmlWriter(string filePath, Encoding encoding, Formatting formatacao, bool CompatibildiadeTISSNET)
            : base(filePath, encoding)
        {
            this.Formatting = formatacao;
            this.encode = encoding;
            this.HashModoCompatibilidade = CompatibildiadeTISSNET;
            this.inicializavars();
        }

        private void inicializavars()
        {
            this.hash = new MD5CryptoServiceProvider();
            this._DebugON = false;
            this._HashArquivo = "";
            this.comentarioAmil = "";
            this._DebugConteudo = "";
            this._DebugTraceFile = "";
        }

        public override void WriteStartDocument()
        {
            base.WriteStartDocument();
            if (!(this.comentarioAmil != ""))
                return;
            this.WriteComment(this.comentarioAmil);
        }

        public override void WriteDocType(string name, string pubid, string sysid, string subset)
        {
            base.WriteDocType(name, pubid, sysid, subset);
        }

        public override void WriteBase64(byte[] buffer, int index, int count)
        {
            base.WriteBase64(buffer, index, count);
            this.hash.TransformBlock(buffer, index, count, (byte[])null, 0);
            if (!this._DebugON)
                return;
            tissXmlWriter tissXmlWriter = this;
            string str = tissXmlWriter._DebugConteudo + this.encode.GetString(buffer);
            tissXmlWriter._DebugConteudo = str;
        }

        public override void WriteStartAttribute(string prefix, string localName, string ns)
        {
            this.attrwrt = true;
        }

        public override void WriteEndAttribute()
        {
            this.attrwrt = false;
        }

        public override void WriteRaw(string data)
        {
            data = RemoveSpecialCharacters(data);
            if (this.attrwrt || this.WriteState != WriteState.Element)
                return;
            string str1 = data.Replace("\r", " ").Replace("\n", "").Trim();
            this.hash.TransformBlock(this.encode.GetBytes(str1), 0, str1.Length, (byte[])null, 0);
            base.WriteRaw(str1);
            if (this._DebugON)
            {
                tissXmlWriter tissXmlWriter = this;
                string str2 = tissXmlWriter._DebugConteudo + str1;
                tissXmlWriter._DebugConteudo = str2;
            }
        }

        public override void WriteString(string text)
        {
            text = RemoveSpecialCharacters(text);
            if (this.attrwrt || this.WriteState != WriteState.Element)
                return;
            if (text == "HASHCODEXMLSANSPADRAO")
            {
                this.hash.TransformFinalBlock(this.encode.GetBytes(""), 0, 0);
                this._HashArquivo = Conversores.ByteArrayToHexString(this.hash.Hash);
                base.WriteString(this._HashArquivo);
                this.hash.Clear();
                if (this._DebugON)
                {
                    try
                    {
                        if (Directory.Exists(Path.GetDirectoryName(this._DebugTraceFile)))
                            File.WriteAllText(this._DebugTraceFile, this._DebugConteudo);
                    }
                    catch
                    {
                    }
                }
            }
            else
            {
                string str1 = text.Replace("\r", " ").Replace("\n", "").Trim();
                this.hash.TransformBlock(this.encode.GetBytes(str1), 0, str1.Length, (byte[])null, 0);
                base.WriteString(str1);
                if (this._DebugON)
                {
                    tissXmlWriter tissXmlWriter = this;
                    string str2 = tissXmlWriter._DebugConteudo + str1;
                    tissXmlWriter._DebugConteudo = str2;
                }
            }
        }

        public static string RemoveSpecialCharacters(string s)
        {
            string SpecialCharacters = "àèìòùâêîôûäëïöüáéíóúãõñçÀÈÌÒÙÂÊÎÔÛÄËÏÖÜÁÉÍÓÚÃÕÑÇ´`^~¨";
            string NoCharacters = "aeiouaeiouaeiouaeiouaoncAEIOUAEIOUAEIOUAEIOUAONC     ";

            for (int i = 0; i < SpecialCharacters.Length; i++)
                s = s.Replace(SpecialCharacters[i], NoCharacters[i]);

            return s;
        }
    }
}