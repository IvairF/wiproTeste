using System.Collections.Generic;
using System.Web;
using System.Web.Optimization;

namespace Amil.AsmWebCad.UI
{
    internal static class BundleExtensions
    {
        public static Bundle ForceOrdered(this Bundle sb)
        {
            sb.Orderer = new AsIsBundleOrderer();
            return sb;
        }
    }

    internal class AsIsBundleOrderer : IBundleOrderer
    {
        public IEnumerable<BundleFile> OrderFiles(BundleContext context, IEnumerable<BundleFile> files)
        {
            return files;
        }
    }

    internal class CssRewriteUrlTransformWrapper : IItemTransform
    {
        public string Process(string includedVirtualPath, string input)
        {
            return new CssRewriteUrlTransform().Process("~" + VirtualPathUtility.ToAbsolute(includedVirtualPath), input);
        }
    }
    public class BundleConfig
    {
        // For more information on Bundling, visit http://go.microsoft.com/fwlink/?LinkId=254725
        public static void RegisterBundles(BundleCollection bundles)
        {
            //BundleTable.EnableOptimizations = true;
            BundleTable.Bundles.FileExtensionReplacementList.Clear();

            bundles.Add(
                new ScriptBundle("~/bundles/jquery")
                .Include(
                        "~/Scripts/JQuery/jquery-3.1.1.js",
                        "~/Scripts/Outros/metisMenu.js",
                        "~/Scripts/Outros/template.js",
                        "~/Scripts/Outros/morris.js",
                        "~/Scripts/Outros/funcoes.js"
                ).ForceOrdered());

            bundles.Add(new ScriptBundle("~/bundles/plugins").Include(
                "~/Scripts/Moment/moment-with-locales.js",
                "~/Scripts/Moment/moment.js",
                "~/Scripts/Moment/pt-br.js",
                "~/Scripts/Mask/jquery.mask.js",
                "~/Scripts/Datatables/datatables.js",
                "~/Scripts/Download/jquery.fileDownload.js").ForceOrdered());

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                "~/Scripts/Bootstrap/bootstrap.js",
                "~/Scripts/Bootstrap/bootstrap-datetimepicker.min.js",
                "~/Scripts/Bootstrap/bootstrap-datepicker.pt-BR.js",
                "~/Scripts/Bootstrap/bootstrap-datetimepicker.js").ForceOrdered());

            bundles.Add(
                new ScriptBundle("~/bundles/jquery-ui")
                    .Include("~/Scripts/JQuery/jquery-ui.js")
                );

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/JQuery/jquery.unobtrusive*",
                        "~/Scripts/JQuery/jquery.validate*").ForceOrdered());

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/Outros/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/AmilFramework").Include("~/Scripts/Outros/amil.framework-2.0.js"));
            bundles.Add(new ScriptBundle("~/bundles/AmilFrameworkMapas").Include("~/Scripts/Outros/Amil.Framework.Maps.js"));            
            bundles.Add(new ScriptBundle("~/bundles/tipoDocumento").Include("~/Scripts/Paginas/tipoDocumento.js"));
            bundles.Add(new ScriptBundle("~/bundles/unidade").Include("~/Scripts/Paginas/unidade.js"));
            bundles.Add(new ScriptBundle("~/bundles/unidadeNow").Include("~/Scripts/Paginas/unidadeNow.js"));
            bundles.Add(new ScriptBundle("~/bundles/grupo").Include("~/Scripts/Paginas/grupo.js"));
            bundles.Add(new ScriptBundle("~/bundles/curso").Include("~/Scripts/Paginas/curso.js"));
            bundles.Add(new ScriptBundle("~/bundles/usuario").Include("~/Scripts/Paginas/usuario.js"));
            bundles.Add(new ScriptBundle("~/bundles/perfil").Include("~/Scripts/Paginas/perfil.js"));
            bundles.Add(new ScriptBundle("~/bundles/home").Include("~/Scripts/Paginas/home.js"));
            bundles.Add(new ScriptBundle("~/bundles/aviso").Include("~/Scripts/Paginas/aviso.js"));
            bundles.Add(new ScriptBundle("~/bundles/workflow").Include("~/Scripts/Paginas/workflow.js"));            
            bundles.Add(new ScriptBundle("~/bundles/configuracaoAlerta").Include("~/Scripts/Paginas/configuracaoAlerta.js"));
            bundles.Add(new ScriptBundle("~/bundles/configuracaoGeral").Include("~/Scripts/Paginas/configuracaoGeral.js"));
            bundles.Add(new ScriptBundle("~/bundles/especialidadenow").Include("~/Scripts/Paginas/especialidadenow.js"));
            bundles.Add(new ScriptBundle("~/bundles/especialidadeporunidadenow").Include("~/Scripts/Paginas/especialidadeporunidadenow.js"));
            
            //bundles.Add(new ScriptBundle("~/bundles/convenio").Include("~/Scripts/Scripts/Convenio.js")); //Alteração Gabriel

            var cssUrlTransform = new CssRewriteUrlTransformWrapper();

            bundles.Add(
                new StyleBundle("~/bundles/controls")
                    .Include("~/Content/Template/controls/WizardCSS.css", cssUrlTransform)
                    .Include("~/Content/Template/controls/resumoWizard.css", cssUrlTransform)
                    .Include("~/Content/Template/controls/CheckBoxListCSS.css", cssUrlTransform)
                );

            bundles.Add(
                new StyleBundle("~/Content/css")
                    .Include("~/Content/Template/bootstrap/css/bootstrap.css", cssUrlTransform)
                    .Include("~/Content/Template/bootstrap/css/bootstrap-datetimepicker.css", cssUrlTransform)
                    .Include("~/Content/Template/metisMenu/metisMenu.min.css", cssUrlTransform)
                    .Include("~/Content/Template/dist/css/template.css", cssUrlTransform)
                    .Include("~/Content/Template/morris/morris.css", cssUrlTransform)
                    .Include("~/Content/site.css", cssUrlTransform)
                    .Include("~/Content/Template/font-awesome/css/font-awesome.css", cssUrlTransform)
                );

            bundles.Add(
                new StyleBundle("~/Content/UI")
                    .Include("~/Content/themes/UI/jquery-ui.css", cssUrlTransform)
                    .Include("~/Content/themes/UI/jquery-ui.structure.css", cssUrlTransform)
                    .Include("~/Content/themes/UI/jquery-ui.theme.css", cssUrlTransform)
                );

            bundles.Add(new StyleBundle("~/CircularTabs").Include(
                "~/Content/Template/bootstrap/css/circularBootstrapTabs.css"));

            bundles.Add(new StyleBundle("~/Content/css/tabs").Include(
                "~/Content/Template/bootstrap/css/circularBootstrapTabs.css"));
        }
    }
}