//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SIAC.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class AviQuestaoPessoaResposta
    {
        public int CodPessoaFisica { get; set; }
        public int NumIdentificador { get; set; }
        public int CodTipoAvaliacao { get; set; }
        public int Semestre { get; set; }
        public int Ano { get; set; }
        public int CodAviIndicador { get; set; }
        public int CodAviCategoria { get; set; }
        public int CodAviModulo { get; set; }
        public int CodOrdem { get; set; }
        public int CodRespostaOrdem { get; set; }
        public Nullable<int> RespAlternativa { get; set; }
        public string RespDiscursiva { get; set; }
        public Nullable<System.DateTime> RespData { get; set; }
    
        public virtual AviQuestao AviQuestao { get; set; }
        public virtual PessoaFisica PessoaFisica { get; set; }
    }
}
