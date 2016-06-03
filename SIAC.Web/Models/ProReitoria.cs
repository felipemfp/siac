namespace SIAC.Models
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("ProReitoria")]
    public partial class ProReitoria
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ProReitoria()
        {
            PessoaLocalTrabalho = new HashSet<PessoaLocalTrabalho>();
            AviPublico = new HashSet<AviPublico>();
        }

        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int CodInstituicao { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int CodProReitoria { get; set; }

        public int CodPessoaJuridica { get; set; }

        public int CodColaboradorProReitor { get; set; }

        [StringLength(10)]
        public string Sigla { get; set; }

        public virtual Colaborador Colaborador { get; set; }

        public virtual Instituicao Instituicao { get; set; }

        public virtual PessoaJuridica PessoaJuridica { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PessoaLocalTrabalho> PessoaLocalTrabalho { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<AviPublico> AviPublico { get; set; }
    }
}