using Amil.AppHospitais.APIClient;
using Amil.AsmWebCad.UI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DTO = Amil.AppHospitais.DTO;

namespace Amil.AsmWebCad.UI.Controllers
{
    public class ConvenioController : Controller
    {
        //
        // GET: /Convenio/
        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Convenio/{id}
        public ActionResult Edit(int id = 0)
        {
            var convenioClient = new ConvenioClient(Session);
            DTO.Convenio result = null;
            if (id > 0)
                result = convenioClient.ListarPorId(id);
            ViewBag.TiposConvenio = new List<SelectListItem>();
            ViewBag.TiposConvenio.Add(new SelectListItem { Value = "1", Text = "Grupo Amil" });
            ViewBag.TiposConvenio.Add(new SelectListItem { Value = "2", Text = "Particular" });
            ViewBag.TiposConvenio.Add(new SelectListItem { Value = "0", Text = "Outros Convênios" });

            return View(result);
        }
        [HttpPost]
        public bool Edit(ConvenioViewModel convenio)
        {
            //ModelState.Remove("CodCorporativo");
            //ModelState.Remove("RegistroANS");
            //if (!ModelState.IsValid)
            //    return false;

            if (convenio.Id == 0)
                convenio.isAtivo = true;

            var convenioDTO = new DTO.Convenio()
            {
                Id = convenio.Id,
                RegistroANS = convenio.RegistroANS,
                CodCorporativo = convenio.CodCorporativo,
                isElegibilidade = convenio.isElegibilidade,
                isAtivo = convenio.isAtivo,
                TipoConvenio = convenio.TipoConvenio,
                Nome = convenio.Nome,
                NomeAbreviado = convenio.NomeAbreviado,
            };

            var convenioClient = new ConvenioClient(Session);
            var id = convenioClient.Gravar(convenioDTO);
            return (id > 0);
        }
        public PartialViewResult GridConvenios()
        {
            var client = new ConvenioClient(Session);
            var result = client.Listar();
            return PartialView("_GridConvenios", result);
        }
    }
}