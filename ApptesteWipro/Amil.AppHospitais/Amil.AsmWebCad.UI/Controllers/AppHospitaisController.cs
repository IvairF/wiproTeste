using System.Collections.Generic;
using System.Web.Mvc;
using DTO = Amil.AppHospitais.DTO;
using MessagingToolkit.QRCode.Codec;
using System.Drawing;
using System.Drawing.Imaging;
using Amil.AppHospitais.DTO;
using Amil.AppHospitais.APIClient;
using System;
using System.IO;


namespace Amil.AsmWebCad.UI.Controllers
{
    public class AppHospitaisController : Controller
    {
        
        public ActionResult Unidades()
        {
            return View();
        }

        public PartialViewResult GridUnidades()
        {
            var unidadeClient = new UnidadeClient(Session);
            var result = unidadeClient.Listar();
            
            return PartialView("_GridUnidades", result);
        }

        public PartialViewResult GridEspecialidades()
        {
            var especialidadeClient = new EspecialidadeClient(Session);
            var lista = especialidadeClient.Listar();
            return PartialView("_GridEspecialidades", lista);
        }

        public PartialViewResult GridConvenios()
        {
            var client = new ConvenioClient(Session);
            var result = client.Listar();
            return PartialView("_GridConvenios", result);
        }

        public ActionResult EditarCriarUnidade(int id = 0)
        {
            DTO.UnidadeDTO dto = new DTO.UnidadeDTO();

            if (id > 0)
            {
                dto = (new UnidadeClient(Session)).Obter(id);

                //Tratamento do CEP para retornar oito digitos.
                if (dto.CEP.Length < 8)
                    dto.CEP = string.Concat("0", dto.CEP);
            }

            return View(dto);
        }

        public static Image ScaleImage(Image image, int maxWidth, int maxHeight)
        {
            var ratioX = (double)maxWidth / image.Width;
            var ratioY = (double)maxHeight / image.Height;
            var ratio = Math.Min(ratioX, ratioY);

            var newWidth = (int)(image.Width * ratio);
            var newHeight = (int)(image.Height * ratio);

            var newImage = new Bitmap(newWidth, newHeight);

            using (var graphics = Graphics.FromImage(newImage))
                graphics.DrawImage(image, 0, 0, newWidth, newHeight);

            return newImage;
        }

        [HttpPost]
        public bool EditarCriarUnidade(UnidadeDTO form)
        {

            if (form.Fotos != null)
            {
                foreach (var foto in form.Fotos)
                {
                    var image = Image.FromStream(new MemoryStream(foto.fotoByte));
                    if (image.Height > 300 || image.Width > 300)
                    {
                        var newImage = ScaleImage(image, 300, 300);
                        ImageConverter _imageConverter = new ImageConverter();
                        foto.fotoByte = (byte[])_imageConverter.ConvertTo(newImage, typeof(byte[]));
                        foto.identificador = 0;
                        if (newImage != null)
                            newImage.Dispose();
                    }
                }
            }


            var unidadeClient = new UnidadeClient(Session);
            var result = unidadeClient.Gravar(form);
            
            return result;
            
        }

        public ActionResult ConfirmacaoNovaUnidade(UnidadeDTO unidade)
        {
            return View(unidade);
        }

        public ActionResult ConfirmacaoEditarUnidade(UnidadeDTO unidade)
        {
            return View(unidade);
        }

        [HttpPost]
        public PartialViewResult GerarQRCode(string id)
        {
            QRCodeEncoder qrCodecEncoder = new QRCodeEncoder();
            qrCodecEncoder.QRCodeBackgroundColor = System.Drawing.Color.White;
            qrCodecEncoder.QRCodeForegroundColor = System.Drawing.Color.Black;
            qrCodecEncoder.CharacterSet = "UTF-8";
            qrCodecEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;
            qrCodecEncoder.QRCodeScale = 25;
            qrCodecEncoder.QRCodeVersion = 0;
            qrCodecEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.Q;
            Bitmap img = qrCodecEncoder.Encode(id);
            string file = "QRCode_" + id + ".jpg";
            string path = Server.MapPath("~/Content/QRCodes/") + file;
            img.Save(path, ImageFormat.Jpeg);

            return PartialView("_QRCode", file);
        }

        public FileResult SalvarQRCode(string id)
        {
            string strPhysicalPath = Server.MapPath("~/Content/QRCodes/");
            string fileName = "QRCode_" + id + ".jpg";
            byte[] fileBytes = System.IO.File.ReadAllBytes(strPhysicalPath + fileName);
            return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
        }

        [HttpPost]
        public bool ValidarCodBeaconUnico(string codBeacon)
        {
            var beaconClient = new BeaconClient(Session);
            return beaconClient.ValidarCodBeaconUnico(codBeacon);
        }

        public ActionResult PesquisarUnidadeNow(int id)
        {
            var unidadeClient = new UnidadeClient(Session);
            var result = unidadeClient.PesquisarUnidadeNow(id);
            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}
