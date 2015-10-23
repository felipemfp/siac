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
    
    public partial class Reitoria
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Reitoria()
        {
            this.AviPublico = new HashSet<AviPublico>();
        }
    
        public int CodReitoria { get; set; }
        public int CodInstituicao { get; set; }
        public int CodPessoaJuridica { get; set; }
        public int CodColaboradorReitor { get; set; }
        public string Sigla { get; set; }
    
        public virtual Colaborador Colaborador { get; set; }
        public virtual Instituicao Instituicao { get; set; }
        public virtual PessoaJuridica PessoaJuridica { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<AviPublico> AviPublico { get; set; }
    }
}
