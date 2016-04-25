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
    
    public partial class SimProva
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public SimProva()
        {
            this.SimCandidatoProva = new HashSet<SimCandidatoProva>();
            this.SimProvaQuestao = new HashSet<SimProvaQuestao>();
        }
    
        public int Ano { get; set; }
        public int NumIdentificador { get; set; }
        public int CodDiaRealizacao { get; set; }
        public int CodProva { get; set; }
        public Nullable<int> CodProfessor { get; set; }
        public int CodDisciplina { get; set; }
        public int QteQuestoes { get; set; }
        public string Titulo { get; set; }
        public string Descricao { get; set; }
        public Nullable<decimal> MediaAritmeticaAcerto { get; set; }
        public Nullable<decimal> DesvioPadraoAcerto { get; set; }
        public Nullable<int> Peso { get; set; }
    
        public virtual Disciplina Disciplina { get; set; }
        public virtual Professor Professor { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SimCandidatoProva> SimCandidatoProva { get; set; }
        public virtual SimDiaRealizacao SimDiaRealizacao { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SimProvaQuestao> SimProvaQuestao { get; set; }
    }
}
