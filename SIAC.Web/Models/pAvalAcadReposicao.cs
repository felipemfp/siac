﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SIAC.Models
{
    public partial class AvalAcadReposicao
    {
        public AvalAcademica Academica => this.Justificacao.FirstOrDefault()?.AvalPessoaResultado.Avaliacao.AvalAcademica;
        public Disciplina Disciplina => this.Justificacao.FirstOrDefault()?.AvalPessoaResultado.Avaliacao.AvalAcademica.Disciplina;
        public Professor Professor => this.Justificacao.FirstOrDefault()?.Professor;

        public List<Aluno> Alunos
        {
            get
            {
                var alunos = this.Justificacao.FirstOrDefault()?.AvalPessoaResultado.Avaliacao.AvalAcademica.Alunos;
                var retorno = new List<Aluno>();
                foreach (var a in alunos)
                {
                    if (this.Justificacao.FirstOrDefault(j=>j.CodPessoaFisica == a.Usuario.CodPessoaFisica) != null)
                    {
                        retorno.Add(a);
                    }
                }
                return retorno;
            }
        }

        public List<Aluno> AlunosRealizaram
        {
            get
            {
                List<Aluno> result = new List<Aluno>();
                foreach (Aluno a in this.Alunos)
                {
                    var lstRespostas = this.Avaliacao.PessoaResposta.Where(p => p.CodPessoaFisica == a.Usuario.CodPessoaFisica);
                    if (lstRespostas.Count() > 0)
                        result.Add(a);
                }
                return result;
            }
        }

        private static dbSIACEntities contexto { get { return Repositorio.GetInstance(); } }

        public static AvalAcadReposicao ListarPorCodigoAvaliacao(string codigo)
        {
            int numIdentificador = 0;
            int semestre = 0;
            int ano = 0;

            if (codigo.Length == 13)
            {

                int.TryParse(codigo.Substring(codigo.Length - 4), out numIdentificador);
                codigo = codigo.Remove(codigo.Length - 4);
                int.TryParse(codigo.Substring(codigo.Length - 1), out semestre);
                codigo = codigo.Remove(codigo.Length - 1);
                int.TryParse(codigo.Substring(codigo.Length - 4), out ano);
                codigo = codigo.Remove(codigo.Length - 4);

                int codTipoAvaliacao = TipoAvaliacao.ListarPorSigla(codigo).CodTipoAvaliacao;

                AvalAcadReposicao avaliacao = contexto.AvalAcadReposicao.FirstOrDefault(aval => aval.Ano == ano && aval.Semestre == semestre && aval.NumIdentificador == numIdentificador && aval.CodTipoAvaliacao == codTipoAvaliacao);

                return avaliacao;
            }
            return null;
        }

        public static List<AvalAcadReposicao> ListarPorProfessor(int codProfessor)
        {
            return contexto.AvalAcadReposicao.Where(ac => ac.Justificacao.FirstOrDefault().Professor.CodProfessor == codProfessor)
                                         .OrderByDescending(ac => ac.Avaliacao.DtCadastro)
                                         .ToList();
        }

        public static List<AvalAcadReposicao> ListarPorAluno(int codAluno)
        {
            var aluno = Aluno.ListarPorCodigo(codAluno);

            return contexto.AvalAcadReposicao
                .Where(a => a.Justificacao.FirstOrDefault(j => j.CodPessoaFisica == aluno.Usuario.CodPessoaFisica) != null)
                .OrderByDescending(a => a.Avaliacao.DtCadastro)
                .ToList();
        }

        public static List<AvalAcadReposicao> ListarAgendadaPorAluno(int codAluno)
        {
            var aluno = Aluno.ListarPorCodigo(codAluno);

            return contexto.AvalAcadReposicao
                .Where(a => a.Justificacao.FirstOrDefault(j => j.CodPessoaFisica == aluno.Usuario.CodPessoaFisica) != null
                    && a.Avaliacao.DtAplicacao.HasValue
                    && a.Avaliacao.AvalPessoaResultado.Count == 0
                    && !a.Avaliacao.FlagArquivo)
                .OrderBy(a => a.Avaliacao.DtAplicacao)
                .ToList();
        }

        public static List<AvalAcadReposicao> ListarAgendadaPorProfessor(int codProfessor)
        {
            return contexto.AvalAcadReposicao
                .Where(a => a.Justificacao.Count > 0 && a.Justificacao.FirstOrDefault().CodProfessor == codProfessor
                    && a.Avaliacao.DtAplicacao.HasValue
                    && a.Avaliacao.AvalPessoaResultado.Count == 0
                    && !a.Avaliacao.FlagArquivo)
                .OrderBy(a => a.Avaliacao.DtAplicacao)
                .ToList();
        }

        public static List<AvalAcadReposicao> ListarAgendadaPorColaborador(int codColaborador)
        {
            return contexto.AvalAcadReposicao
                .Where(a =>
                    a.Justificacao.Count > 0
                    && a.Avaliacao.DtAplicacao.HasValue
                    && a.Avaliacao.AvalPessoaResultado.Count == 0
                    && !a.Avaliacao.FlagArquivo &&
                    (
                        a.Justificacao.FirstOrDefault().AvalPessoaResultado.Avaliacao.AvalAcademica.Turma.Curso.CodColabCoordenador == codColaborador
                        || a.Justificacao.FirstOrDefault().AvalPessoaResultado.Avaliacao.AvalAcademica.Turma.Curso.Diretoria.CodColaboradorDiretor == codColaborador
                        || a.Justificacao.FirstOrDefault().AvalPessoaResultado.Avaliacao.AvalAcademica.Turma.Curso.Diretoria.Campus.CodColaboradorDiretor == codColaborador
                        || a.Justificacao.FirstOrDefault().AvalPessoaResultado.Avaliacao.AvalAcademica.Turma.Curso.Diretoria.Campus.Instituicao.Reitoria.Where(r => r.CodColaboradorReitor == codColaborador).Count() > 0
                    ))
                .OrderBy(a => a.Avaliacao.DtAplicacao)
                .ToList();
        }

        public static List<AvalAcadReposicao> ListarAgendadaPorUsuario(Usuario usuario)
        {
            switch (usuario.CodCategoria)
            {
                case 1:
                    return ListarAgendadaPorAluno(usuario.Aluno.First().CodAluno);
                case 2:
                    return ListarAgendadaPorProfessor(usuario.Professor.First().CodProfessor);
                case 3:
                    return ListarAgendadaPorColaborador(usuario.Colaborador.First().CodColaborador);
                default:
                    return new List<AvalAcadReposicao>();
            }
        }
    }
}