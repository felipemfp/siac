﻿/*
This file is part of SIAC.

Copyright (C) 2016 Felipe Mateus Freire Pontes <felipemfpontes@gmail.com>
Copyright (C) 2016 Francisco Bento da Silva Júnior <francisco.bento.jr@hotmail.com>

SIAC is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details. 
*/
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace SIAC.Models
{
    public partial class PessoaFisica
    {
        [NotMapped]
        public string PrimeiroNome => this.Nome.Split(' ').First();

        [NotMapped]
        public string UltimoNome => this.Nome.Split(' ').Last();

        private static Contexto contexto => Repositorio.GetInstance();

        public static int Inserir(PessoaFisica pessoaFisica)
        {
            contexto.PessoaFisica.Add(pessoaFisica);
            contexto.SaveChanges();
            return pessoaFisica.CodPessoa;
        }

        public static void AdicionarOcupacao(int codPessoaFisica, int codOcupacao)
        {
            PessoaFisica pessoa = ListarPorCodigo(codPessoaFisica);
            pessoa?.Ocupacao.Add(Models.Ocupacao.ListarPorCodigo(codOcupacao));
            contexto.SaveChanges();
        }

        public static void RemoverOcupacao(int codPessoaFisica, int codOcupacao)
        {
            PessoaFisica pessoa = ListarPorCodigo(codPessoaFisica);
            pessoa?.Ocupacao.Remove(Models.Ocupacao.ListarPorCodigo(codOcupacao));
            contexto.SaveChanges();
        }

        public static List<PessoaFisica> Listar() => contexto.PessoaFisica.ToList();

        public static PessoaFisica ListarPorCpf(string cpf) => contexto.PessoaFisica.FirstOrDefault(p => p.Cpf == cpf);

        public static PessoaFisica ListarPorCodigo(int codPessoaFisica) => contexto.PessoaFisica.Find(codPessoaFisica);

        public static PessoaFisica ListarPorMatricula(string matricula) => contexto.Usuario.Find(matricula)?.PessoaFisica;

        public static List<PessoaFisica> ListarPorTurma(string codTurma)
        {
            DateTime dtHoje = DateTime.Now;
            int ano = dtHoje.Year;
            int semestre = dtHoje.SemestreAtual();
            return Turma.ListarPorCodigo(codTurma).TurmaDiscAluno.Where(a => a.AnoLetivo == ano && a.SemestreLetivo == semestre).Select(a => a.Aluno.Usuario.PessoaFisica).ToList();
        }

        public static List<PessoaFisica> ListarPorCurso(int codCurso)
        {
            DateTime dtHoje = DateTime.Now;
            int ano = dtHoje.Year;
            int semestre = dtHoje.SemestreAtual();
            List<PessoaFisica> lstPessoaFisica = new List<PessoaFisica>();
            foreach (var turma in Curso.ListarPorCodigo(codCurso).Turma)
                lstPessoaFisica.AddRange(turma.TurmaDiscAluno.Where(a => a.AnoLetivo == ano && a.SemestreLetivo == semestre).Select(a => a.Aluno.Usuario.PessoaFisica).ToList());
            return lstPessoaFisica;
        }

        public static List<PessoaFisica> ListarPorDiretoria(string codComposto)
        {
            DateTime dtHoje = DateTime.Now;
            int ano = dtHoje.Year;
            int semestre = dtHoje.SemestreAtual();

            List<PessoaFisica> lstPessoaFisica = new List<PessoaFisica>();

            foreach (var curso in Diretoria.ListarPorCodigo(codComposto).Curso)
                foreach (var turma in curso.Turma)
                    lstPessoaFisica.AddRange(turma.TurmaDiscAluno.Where(a => a.AnoLetivo == ano && a.SemestreLetivo == semestre).Select(a => a.Aluno.Usuario.PessoaFisica).ToList());

            return lstPessoaFisica;
        }

        public static List<PessoaFisica> ListarPorCampus(string codComposto)
        {
            DateTime dtHoje = DateTime.Now;
            int ano = dtHoje.Year;
            int semestre = dtHoje.SemestreAtual();

            List<PessoaFisica> lstPessoaFisica = new List<PessoaFisica>();

            foreach (var diretoria in Campus.ListarPorCodigo(codComposto).Diretoria)
                foreach (var curso in diretoria.Curso)
                    foreach (var turma in curso.Turma)
                        lstPessoaFisica.AddRange(turma.TurmaDiscAluno.Where(a => a.AnoLetivo == ano && a.SemestreLetivo == semestre).Select(a => a.Aluno.Usuario.PessoaFisica).ToList());

            return lstPessoaFisica;
        }
    }
}