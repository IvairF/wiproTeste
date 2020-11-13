using System.Web.Mvc;
using System.Collections.Generic;

namespace Amil.AsmWebCad.UI.Controllers
{
    public class BaseController : Controller
    {

        protected JsonResult JsonFromPagedList(dynamic pagedList)
        {
            return JsonFromPagedList(pagedList, pagedList.Items);
        }

        protected JsonResult JsonFromPagedList(dynamic pagedList, object data)
        {
            return new JsonResult
            {
                Data = new
                {
                    Erro = false,
                    data,
                    recordsFiltered = pagedList.TotalCount,
                    recordsTotal = pagedList.TotalCount
                },
                ContentType = "application/json",
                ContentEncoding = System.Text.Encoding.UTF8,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet,
                MaxJsonLength = int.MaxValue
            };
        }

        /// <summary>
        /// Método responsável por montar lista de status para dropdown.
        /// </summary>
        /// <param name="ativo">Indicador do valor que será selecionado.</param>
        /// <returns>Lista de status.</returns>
        internal SelectList BuscarAtivoInativo(string ativo)
        {
            var  vativo = false;
            var  vinativo = false;
            var  vbloqueado = false;
          
            switch (ativo)
            {
                case "A":
                    vativo = true;
                    break;
                case "I":
                    vinativo = true;
                    break;
                default:
                    vbloqueado = true;
                    break;
            }


            var itemAtivo = new SelectListItem { Text = Resources.Resource.Ativo, Value = "A", Selected = vativo == true };
            var itemInativo = new SelectListItem { Text = Resources.Resource.Inativo, Value = "I", Selected = vinativo == true };
            var itemBloqueado = new SelectListItem { Text = Resources.Resource.Bloqueado, Value = "B", Selected = vbloqueado == true };
            var itens = new List<SelectListItem> { itemAtivo, itemInativo, itemBloqueado };

            return new SelectList(itens, "Value", "Text");
        }
    }
}