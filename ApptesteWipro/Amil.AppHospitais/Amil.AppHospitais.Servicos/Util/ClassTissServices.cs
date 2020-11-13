using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Web;

namespace Amil.AppHospitais.Servicos.Util
{
    [ComVisible(true)]
    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("TISS30")]
    public class ClassTiss30
    {
        public object RemoveSpecialCharactersInObject<T>(ref T input)
        {
            var props = input.GetType().GetProperties();

            foreach (PropertyInfo propertyInfo in props)
            {
                object objectValue = propertyInfo.GetValue(input, null);

                if (objectValue != null && objectValue.GetType() == typeof(System.String) &&
                    propertyInfo.GetValue(input, null) != null)
                {
                    propertyInfo.SetValue(input,
                                          tissXmlWriter.RemoveSpecialCharacters(
                                              propertyInfo.GetValue(input, null).ToString().Trim()), null);
                }
                else
                {
                    if (objectValue != null && objectValue.GetType().IsArray)
                    {
                        for (int i = 0; i < ((object[])objectValue).Length; i++)
                        {
                            object obj = ((object)((object[])objectValue)[i]);

                            RemoveSpecialCharactersInObject(ref obj);
                        }
                    }
                    else if (objectValue != null && objectValue.GetType() != typeof(System.DateTime))
                        RemoveSpecialCharactersInObject(ref objectValue);
                }
            }
            return input;
        }
    }
}