using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Amil.AsmWebCad.Utils
{
    public static class Util
    {
        /// <summary>
        /// Busca o HTML pelo nome do arquivo
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static string GetHtmlFile(string filename)
        {
            var sBuilder = new StringBuilder();
            using (var sr = new StreamReader(filename))
            {
                long iCaracter;
                while ((iCaracter = sr.Read()) != -1)
                {
                    var caracter = (char)iCaracter;
                    sBuilder.Append(caracter.ToString());
                }
                sr.Close();
            }
            return sBuilder.ToString();
        }

        /// <summary>
        /// verifica se o caracter é uma letra
        /// </summary>
        /// <param name="c">caracter a verificar</param>
        /// <returns>true ou false</returns>
        private static bool IsLetter(char c)
        {
            return c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z';
        }

        /// <summary>
        /// verifica se o caracter é numérico
        /// </summary>
        /// <param name="c">caracter a verificar</param>
        /// <returns>true ou false</returns>
        private static bool IsDigit(char c)
        {
            return c >= '0' && c <= '9';
        }

        /// <summary>
        /// verifica se é um caracter especial
        /// </summary>
        /// <param name="c">caracter a verificar</param>
        /// <returns>true ou false</returns>
        private static bool IsSymbol(char c)
        {
            return c > 32 && c < 127 && !IsDigit(c) && !IsLetter(c);
        }

        /// <summary>
        /// validade se a senha digitada corresponde as regras impostas
        /// uma letra maiuscula
        /// uma letra minuscula
        /// um numero
        /// um caracterespecial
        /// </summary>
        /// <param name="palavra">palavra a ser checada</param>
        /// <returns>true ou false</returns>
        public static bool ValidaSenha(string palavra)
        {
            return
                palavra.Length >= 8 &&
                (
                    (
                        palavra.Any(char.IsUpper) && ///Amil1234
                        palavra.Any(char.IsLower) &&
                        palavra.Any(char.IsNumber)
                    )
                ||
                    (
                        palavra.Any(char.IsLower) && //amil12##
                        palavra.Any(char.IsNumber) &&
                        palavra.Any(IsSymbol)
                    )
                ||
                    (
                        palavra.Any(char.IsUpper) &&//AMIL1###
                        palavra.Any(char.IsNumber) &&
                        palavra.Any(IsSymbol)
                    )
                ||
                    (
                        palavra.Any(char.IsUpper) &&//Amil###@
                        palavra.Any(char.IsLower) &&
                        palavra.Any(IsSymbol)
                    )
                );
        }

        /// <summary>
        /// Busca o caminho de determinado arquivo
        /// </summary>
        /// <param name="arquivoNome">nome do arquivo</param>
        /// <returns>caminho de diretórios</returns>
        public static string RetornaCaminhoArquivo(string arquivoNome)
        {
            var applicationBase = AppDomain.CurrentDomain.SetupInformation.ApplicationBase;
            return Path.GetFullPath(Path.Combine(applicationBase, arquivoNome));
        }

        /// <summary>
        /// Remove caracteres especiais.
        /// </summary>
        /// <param name="texto">palavra a ser analisada</param>
        /// <returns>palavra sem caracteres</returns>
        public static string RemoverCaracteresEspeciais(string texto)
        {
            const string pattern = @"(?i)[^0-9a-záéíóúàèìòùâêîôûãõç\s]";
            var rgx = new Regex(pattern);
            return rgx.Replace(texto, "");
        }

        /// <summary>
        /// Valida CPF.
        /// </summary>
        /// <param name="cpf">Número do documento.</param>
        /// <returns>true ou false</returns>
        public static bool ValidarCPF(string cpf)
        {
            var multiplicador1 = new[] { 10, 9, 8, 7, 6, 5, 4, 3, 2 };
            var multiplicador2 = new[] { 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 };
            cpf = cpf.Trim();
            cpf = cpf.Replace(".", "").Replace("-", "");
            if (cpf.Length != 11)
                return false;

            switch (cpf)
            {
                case "11111111111": return false;
                case "22222222222": return false;
                case "33333333333": return false;
                case "44444444444": return false;
                case "55555555555": return false;
                case "66666666666": return false;
                case "77777777777": return false;
                case "88888888888": return false;
                case "99999999999": return false;
            }

            var tempCpf = cpf.Substring(0, 9);
            var soma = 0;

            for (var i = 0; i < 9; i++)
                soma += int.Parse(tempCpf[i].ToString()) * multiplicador1[i];
            var resto = soma % 11;
            if (resto < 2)
                resto = 0;
            else
                resto = 11 - resto;
            var digito = resto.ToString();
            tempCpf = tempCpf + digito;
            soma = 0;
            for (var i = 0; i < 10; i++)
                soma += int.Parse(tempCpf[i].ToString()) * multiplicador2[i];
            resto = soma % 11;
            if (resto < 2)
                resto = 0;
            else
                resto = 11 - resto;
            digito = digito + resto;
            return cpf.EndsWith(digito);
        }

        /// <summary>
        /// Valida CNPJ.
        /// </summary>
        /// <param name="cnpj">Número do documento.</param>
        /// <returns>true ou false</returns>
        public static bool ValidarCNPJ(string cnpj)
        {
            var multiplicador1 = new[] { 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 };
            var multiplicador2 = new[] { 6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 };
            cnpj = cnpj.Trim();
            cnpj = cnpj.Replace(".", "").Replace("-", "").Replace("/", "");
            if (cnpj.Length != 14)
                return false;
            var tempCnpj = cnpj.Substring(0, 12);
            var soma = 0;
            for (var i = 0; i < 12; i++)
                soma += int.Parse(tempCnpj[i].ToString()) * multiplicador1[i];
            var resto = soma % 11;
            if (resto < 2)
                resto = 0;
            else
                resto = 11 - resto;
            var digito = resto.ToString();
            tempCnpj = tempCnpj + digito;
            soma = 0;
            for (var i = 0; i < 13; i++)
                soma += int.Parse(tempCnpj[i].ToString()) * multiplicador2[i];
            resto = soma % 11;
            if (resto < 2)
                resto = 0;
            else
                resto = 11 - resto;
            digito = digito + resto;
            return cnpj.EndsWith(digito);
        }

        /// <summary>
        /// valida se o ddd digitado é valido no território brasileiro
        /// </summary>
        /// <param name="ddd">numero a validar</param>
        /// <returns>true ou false</returns>
        public static bool ValidarDDD(string ddd)
        {
            return Convert.ToInt32(ddd) >= 11 && Convert.ToInt32(ddd) <= 99;
        }

        /// <summary>
        /// valida o email digitado para ver se possui as caracteristicas necessárias
        /// </summary>
        /// <param name="email">string do email digitada</param>
        /// <returns>true ou false</returns>
        public static bool ValidarEmail(string email)
        {
            var rg = new Regex(@"^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})$");
            return rg.IsMatch(email);
        }

        /// <summary>
        /// Método responsável por retornar lista de anos.
        /// </summary>
        /// <param name="qtdeAnosAnterior">Qtde de anos anteriores a data da execução do método.</param>
        /// <param name="qtdeAnosPosterior">Qtde de anos posteriores a data da execução do método.</param>
        /// <returns></returns>
        public static List<int> ObterListaAnos(int qtdeAnosAnterior, int qtdeAnosPosterior)
        {
            var anoAnterior = DateTime.Today.Year - qtdeAnosAnterior;
            var anoPosterior = DateTime.Today.Year + qtdeAnosPosterior;
            var lstAnos = new List<int>();

            for (var i = anoAnterior; i <= anoPosterior; i++)
            {
                lstAnos.Add(i);
            }

            return lstAnos;
        }

        /// <summary>
        /// busca a descrição do enum pelo value
        /// </summary>
        /// <param name="value">value do enum</param>
        /// <returns>descrição do enum</returns>
        public static string PegarDescricaoEnum(Enum value)
        {
            var fi = value.GetType().GetField(value.ToString());
            var attributes = (DescriptionAttribute[])fi.GetCustomAttributes(typeof(DescriptionAttribute), false);
            return attributes.Length > 0 ? attributes[0].Description : value.ToString();
        }

        /// <summary>
        /// compara duas strings campo a campo
        /// </summary>
        /// <param name="a">string base</param>
        /// <param name="b">string para comparar</param>
        /// <returns>porcentagem de semelhança</returns>
        public static double CompararString(string a, string b)
        {
            if (a == b)
                return 100;
            if (a.Length == 0 || b.Length == 0)
                return 0;
            double maxLen = a.Length > b.Length ? a.Length : b.Length;
            var minLen = a.Length < b.Length ? a.Length : b.Length;
            var sameCharAtIndex = 0;
            for (var i = 0; i < minLen; i++)
                if (a[i] == b[i])
                    sameCharAtIndex++;
            return sameCharAtIndex / maxLen * 100;
        }

        /// <summary>
        /// gera um novo palavra chave aleatório
        /// </summary>
        /// <returns>palavra chave com 12 casas</returns>
        public static string GerarSenhaNova()
        {
            return System.Web.Security.Membership.GeneratePassword(12, 2);
        }

        /// <summary>
        /// validação do nome com os padrões solicitados
        /// </summary>
        /// <param name="nome">nome a comparar</param>
        /// <returns>true ou false</returns>
        public static bool ValidarNome(string nome)
        {
            var valido = true;
            var nomeSplit = nome.Split(' ');

            string[] ultimoNome = { "I", "Í", "i", "í", "O", "Ó", "Õ", "o", "ó", "õ", "U", "Ú", "u", "ú", "Y", "y", "Ý", "ý" };
            //string[] primeiroNome = { "D", "d", "I", "Í", "i", "í", "O", "Ó", "Õ", "o", "ó", "õ", "U", "Ú", "u", "ú", "Y", "y" };
            string[] primeiroNome = { "D", "d", "I", "Í", "i", "í", "O", "Ó", "Õ", "o", "ó", "õ", "U", "Ú", "u", "ú", "Y", "y", "Ý", "ý" };
            string[] conectivos = { "E", "e", "Y", "y" };
            var rgUltimoNome = new Regex(@"^[A-ZÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑÝ' ]+$", RegexOptions.IgnoreCase);

            var tamanhoSplit = nomeSplit.Length;

            if (!rgUltimoNome.IsMatch(nome))
                valido = false;
            else if (nomeSplit.Length <= 1)
                valido = false;
            else if (nomeSplit[0].Length == 2 && nomeSplit[0].ToLower().Contains("dr"))
                valido = false;
            else if (nomeSplit[0].Length == 1 && !primeiroNome.Contains(nomeSplit[0]))
                valido = false;
            else if (nomeSplit.Last().Length == 1 && !ultimoNome.Contains(nomeSplit.Last()))
                valido = false;

            if (!valido) return false;
            for (var i = 1; i < tamanhoSplit - 1; i++)
            {
                if (nomeSplit[i].Length != 1 || conectivos.Contains(nomeSplit[i])) continue;
                valido = false;
                break;
            }

            return valido;
        }

        public static string UrlWebApi()
        {
            return ConfigurationManager.AppSettings["Amil.AsmWebCad.Api"];
        }
    }
}
