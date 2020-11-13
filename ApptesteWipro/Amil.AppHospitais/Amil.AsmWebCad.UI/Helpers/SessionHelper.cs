using System.Web;
using System.Data.SqlClient;
using System.IO;
using System;
using System.ServiceModel;

namespace Amil.AsmWebCad.UI.Helpers
{
    public static class SessionHelper
    {
        public static T Get<T>(string key)
        {
            key = !string.IsNullOrEmpty(key) ? key : string.Empty;
            var sessionObject = HttpContext.Current.Session[key];
            if (sessionObject == null)
            {
                return default(T);
            }
            try
            {
                return (T)sessionObject;
            }
            catch (SqlException ex)
            {
                return default(T);
            }
            catch (IOException ex)
            {
                return default(T);
            }
            catch (IndexOutOfRangeException ex)
            {
                return default(T);
            }
            catch (FaultException ex)
            {
                return default(T);
            }
            catch (ArgumentException ex)
            {
                return default(T);
            }
            catch (FormatException ex)
            {
                return default(T);
            }
        }

        public static void Set<T>(string key, T entity)
        {
            key = !string.IsNullOrEmpty(key) ? key : string.Empty;
            if (entity == null)
                HttpContext.Current.Session.Remove(key);
            else
                HttpContext.Current.Session.Add(key, entity);
        }


    }
    public static class GlobalVariables
    {

        public static T Get<T>(string key)
        {
            key = !string.IsNullOrEmpty(key) ? key : string.Empty;
            var sessionObject = HttpContext.Current.Application[key];
            if (sessionObject == null)
            {
                return default(T);
            }
            try
            {
                return (T)sessionObject;
            }
            catch (SqlException ex)
            {
                return default(T);
            }
            catch (IOException ex)
            {
                return default(T);
            }
            catch (IndexOutOfRangeException ex)
            {
                return default(T);
            }
            catch (FaultException ex)
            {
                return default(T);
            }
            catch (ArgumentException ex)
            {
                return default(T);
            }
            catch (FormatException ex)
            {
                return default(T);
            }
        }

        public static void Set<T>(string key, T entity)
        {
            // key = !string.IsNullOrEmpty(key) ? key : string.Empty;
            if (entity == null)
                HttpContext.Current.Application.Remove(key);
            else
                HttpContext.Current.Application.Add(key, entity);
        }

    }

}