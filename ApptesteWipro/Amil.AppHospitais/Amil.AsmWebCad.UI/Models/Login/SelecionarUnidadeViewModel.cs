using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace Amil.AsmWebCad.UI.Models.Login
{
    public class SelecionarUnidadeViewModel
    {
        public SelecionarUnidadeViewModel(List<UnidadeViewModel> unidades)
        {
            Unidade = new UnidadeViewModel();

            var itens = (from unidade in unidades
                         select new SelectListItem
                         {
                             Value = unidade.Id.ToString(),
                             Text = unidade.Nome
                         }).ToList();

            ListaUnidades = new SelectList(unidades, "Id", "Nome");
        }

        public UnidadeViewModel Unidade { get; set; }

        public SelectList ListaUnidades { get; private set; }
    }
}