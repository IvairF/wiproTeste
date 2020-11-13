using Amil.AsmWebCad.UI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Amil.AppHospitais.DTO;
using Amil.AsmWebCad.Utils;
using Amil.AsmWebCad.UI.NowWCF;
using System.IO;
using Amil.AsmWebCad.UI.Helpers;
using Amil.AppHospitais.BLL;

namespace Amil.AsmWebCad.UI.Controllers
{
    public class EspecialidadePorUnidadeNowController : BaseController
    {
        //
        // GET: /EspecialidadePorUnidadeNow/

        public ActionResult Pesquisa(string limpar = "", string modal = "")
        {
            EspecialidadeNowModel especialidadeNowModel = new EspecialidadeNowModel();
            if (modal == "S")
            {

                especialidadeNowModel.IdEspecialidade = 1;
                especialidadeNowModel.Descricao = "TESTE";

            }
            else if (especialidadeNowModel == null || limpar == "S")
            {


                especialidadeNowModel.IdEspecialidade = 0;
                especialidadeNowModel.Descricao = "";
                especialidadeNowModel.PrimeiroAcesso = "S";

                Session["especialidadeNowModel"] = null;


            }

            return View(especialidadeNowModel);


        }

        [HttpPost]
        public ActionResult Pesquisa(FormCollection formCollection)
        {
            JsonResult result = null;

            try
            {
                var lstSpec = new List<NowSpecialtyDTO>();
                var paging = formCollection.ToPagingDTO();
                PagedResult<NowSpecialtyDTO> lstSpecDTO;

                lstSpec = new ServiceClient().GetNowSpecialties();

                paging.Order = "Specialty";
                lstSpecDTO = lstSpec.ToPagedResult(paging.Offset, paging.Limit, paging.Order);

                result = JsonFromPagedList(lstSpecDTO);

            }
            catch (TimeoutException ex)
            {
                ModelState.AddModelError("Timeout", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                result = Json(new { Result = 0, Erro = true, Mensagem = ex.Message }, JsonRequestBehavior.AllowGet);
            }

            return result;

        }


        public ActionResult Manutencao()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Manutencao(FormCollection formcollection)
        {
            return View();
        }

        public PartialViewResult CarregarPesquisa(string Nome)
        {
            var especialidadeNowModel = (EspecialidadeNowModel)Session["EspecialidadeNowModel"];
            //if (UnidadeNowModel == null)
            //{
            //    UnidadeNowModel = new UnidadeNowModel();

            especialidadeNowModel = new EspecialidadeNowModel();

            especialidadeNowModel.IdEspecialidade = 1;
            especialidadeNowModel.Descricao = Nome;

            ViewBag.NomeBag = "TESTE";
            //}

            return PartialView("_PesquisaModal");
        }

    }
}
