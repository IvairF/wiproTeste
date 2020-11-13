using System;

namespace Amil.AsmWebCad.Utils
{
    public static class DataParser
    {
        /// <summary>
        /// Method resposible to convert to T.
        /// </summary>
        /// <typeparam name="T">Type that is converted.</typeparam>
        /// <param name="value">Value to convert.</param>
        /// <param name="defaultValue">Default value to return.</param>
        /// <returns>Conversion result.</returns>
        public static T Parse<T>(object value, T defaultValue)
        {
            try
            {
                if (value == null)
                    return defaultValue;
                return (T)Convert.ChangeType(value, typeof(T));
            }
            catch
            {
                return defaultValue;
            }
        }
    }
}
